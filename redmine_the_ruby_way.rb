require 'rubygems'
require 'active_resource'
require 'csv'

ARGV.each do|a|
  puts "Argument: #{a}"
end

# Issue model on the client side
class Issue < ActiveResource::Base
  self.site = ARGV[0]
  self.user = ARGV[1]
  self.password = ARGV[2]
  self.format = :xml

  puts "passed argument " + self_site

  # Or you can use the Redmine-API key
  # self.headers['X-Redmine-API-Key'] = ARGV[1]
end

def retrieve_an_issue(proj_id, query_id)
  Issue.find(:all, :params => { :project_id => proj_id, :query_id => query_id, :include => 'relations'})
end

def csv_headers
  ['Requirement Id', 'Subject', 'Test Feature Id', 'Subject', 'Test Case', 'Subject', 'Test Run', 'Subject', 'Open Defect', 'Description']
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

def add_test_run(row, test_run_row)
  row[6] = test_run_row["id"]
  row[7] = test_run_row["subject"]
end

def add_open_defect(row, defect_row)
  row[8] = test_run_row["id"]
  row[9] = test_run_row["description"]
end

def check_anomalies(row, anomalies_hash)
  anomalies_hash["issue_id"].each do |hash|
    if row[0] == hash["id"]
      row[2] = hash["description"]
      row[3] = hash["reason"]
    end
  end
end

def write_csv(csv, row)

  if row[1].upcase.include?("RISK")

  else
    csv << row
  end

end

requirements = JSON.parse(retrieve_an_issue(2,10).to_json).sort_by! { |hash| hash['id'].to_i }
test_features = JSON.parse(retrieve_an_issue(2,9).to_json).sort_by! { |hash| hash['id'].to_i }
test_cases = JSON.parse(retrieve_an_issue(2,11).to_json).sort_by! { |hash| hash['id'].to_i }
test_runs = JSON.parse(retrieve_an_issue(2,13).to_json).sort_by! { |hash| hash['id'].to_i }
defects = JSON.parse(retrieve_an_issue(2,13).to_json).sort_by! { |hash| hash['id'].to_i }

anomalies = File.read("anomalies.json")
anomalies_hash = JSON.parse(anomalies)

CSV.open('traceability.csv', 'wb') do |csv|
  csv << csv_headers
  requirements.each do |requirement|
    row = []
    add_requirement(row, requirement)
    test_features.each do |test_feature|
      test_feature["relations"].each do |hash|
        if hash["issue_id"] == requirement["id"]
          add_test_feature(row, test_feature)
          test_cases.each do |test_case|
            if test_case["parent"]["id"] == test_feature["id"]
              add_test_case(row, test_case)
              test_runs.each do |test_run|
                if test_run["parent"]["id"] == test_case["id"]
                  add_test_run(row, test_run)
                  write_csv(csv, row)
                end
              end
              write_csv(csv, row) if row.length == 6  # no test run check
            end
          end
          write_csv(csv, row) if row.length == 4  # no test case check
        end
      end
    end
    if row.length == 2  # no test feature check
      check_anomalies(row, anomalies_hash)
      write_csv(csv,row)
    end
  end
end

File.open('builder.xml', 'w') do |file|
  file << retrieve_an_issue(2,10).to_xml
end






