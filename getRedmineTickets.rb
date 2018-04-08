require 'rubygems'
require 'active_resource'
require 'csv'

# Issue model on the client side
class Issue < ActiveResource::Base
  self.site = ARGV[0]
  self.user = ARGV[1]
  self.password = ARGV[2]
  self.format = :xml

  # Or you can use the Redmine-API key
  # self.headers['X-Redmine-API-Key'] = ARGV[1]
end

def retrieve_an_issue(proj_id, query_id)
  Issue.find(:all, :params => { :project_id => proj_id, :query_id => query_id, :include => 'relations'})
end

def getTime
  time = Time.new
  time.strftime("%Y-%m-%d-%H:%M:%S")
end

def csv_headers
  ['Requirement Id', 'Subject', 'Test Feature Id', 'Subject', 'Test Case', 'Subject', 'Test Run', 'Passed', 'Failed', 'Not Run', 'Open Defect', 'Description']
end

def add_requirement(row, requirement)
  row[0] = requirement["id"]
  row[1] = requirement["subject"]
end

def add_test_feature(row, feature_row)
  row[2] = feature_row["id"]
  row[3] = feature_row["subject"]
end

def add_test_case(row, case_row)
  row[4] = case_row["id"]
  row[5] = case_row["subject"]
end

def add_test_run_manual(row, test_run_row)
  row[6] = test_run_row["id"]
  row[7] = test_run_row["subject"]
end

def add_test_run_auto(row, test_run_row)
  row[6] = "build_#{ARGV[3]}-#{getTime}"
  row[7] = test_run_row["results"]["passed"]
  row[8] = test_run_row["results"]["failed"]
  row[9] = test_run_row["results"]["undefined"]
end

def add_open_defect(row, defect_row)
  row[10] = test_run_row["id"]
  row[11] = test_run_row["description"]
end

def check_anomalies(row, anomalies_hash)
  anomalies_hash["issue_id"].each do |hash|
    if row[0] == hash["id"]
      row[2] = hash["description"]
      row[3] = hash["reason"]
    end
  end
end

def write_csv(csv, csv_risk, row)
  if row[1].upcase.include?("RISK")
    csv_risk << row
  else
    csv << row
  end

end

def manual(test_runs_manual, test_case, row, csv, csv_risk)
  test_runs_manual.each do |test_run|
    if test_run["parent"]["id"] == test_case["id"]
      add_test_run_manual(row, test_run)
      write_csv(csv, csv_risk, row)
      create_redmine_ticket(test_run)
    end
  end
end

def create_redmine_ticket(test_run)
  puts test_run["subject"]

  # Creating an issue
  issue = Issue.new(
    :subject => test_run["subject"],
    :project_id => 2,
    :tracker_id => 7
  # custom field with id=2 exist in database
  #  :custom_fields => [{id: 2, value: "IT"}]
  )
  if issue.save
    puts issue.id
  else
    puts issue.errors.full_messages
  end


end

def automation(test_runs_auto_hash, requirement, row, csv, csv_risk)
  test_runs_auto_hash.each do |test_run_auto|
    if test_run_auto["feature"] == requirement["id"]
      add_test_run_auto(row, test_run_auto)
    end
  end
  write_csv(csv, csv_risk, row)
end

requirements = JSON.parse(retrieve_an_issue(2,10).to_json).sort_by! { |hash| hash['id'].to_i }
test_features = JSON.parse(retrieve_an_issue(2,9).to_json).sort_by! { |hash| hash['id'].to_i }
test_cases = JSON.parse(retrieve_an_issue(2,11).to_json).sort_by! { |hash| hash['id'].to_i }
test_runs_manual = JSON.parse(retrieve_an_issue(2,13).to_json).sort_by! { |hash| hash['id'].to_i }

defects = JSON.parse(retrieve_an_issue(2,13).to_json).sort_by! { |hash| hash['id'].to_i }

test_runs_auto = File.read("cucumberResults.json")
test_runs_auto_hash = JSON.parse(test_runs_auto)

anomalies = File.read("anomalies.json")
anomalies_hash = JSON.parse(anomalies)

CSV.open("risks_build_#{ARGV[3]}-#{getTime}.csv", "wb") do |csv_risk|
  csv_risk << csv_headers
  CSV.open("traceability_build_#{ARGV[3]}-#{getTime}.csv", "wb") do |csv|
    csv << csv_headers
    requirements.each do |requirement|
      row = []
      add_requirement(row, requirement)
      test_features.each do |test_feature|
        test_feature["relations"].each do |test_feature_related_to|
          if test_feature_related_to["issue_id"] == requirement["id"]
            add_test_feature(row, test_feature)
            test_cases.each do |test_case|
              if test_case["parent"]["id"] == test_feature["id"]
                add_test_case(row, test_case)
                manual(test_runs_manual, test_case, row, csv, csv_risk)
                if row.length == 6 # no test run manual, so check for automation
                  automation(test_runs_auto_hash, requirement, row, csv, csv_risk,)
                end
              end
            end
            write_csv(csv, csv_risk, row) if row.length == 4  # no test case check
          end
        end
      end
      if row.length == 2  # no test feature check
        check_anomalies(row, anomalies_hash)
        write_csv(csv, csv_risk, row)
      end
    end
  end
end