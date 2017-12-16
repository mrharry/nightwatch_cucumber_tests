require 'csv'

def csv_headers
  ['Requirement Id', 'Subject', 'Test Feature Id', 'Status', 'Subject'  ]
end

def add_test_feature(row, feature_row)
  row[2] = feature_row[0]
  row[3] = feature_row[2]
end

def add_test_case(row, case_row)
  row[4] = case_row[0]
  row[5] = case_row[2]
end

def add_test_run(row, test_run_row)
  row[6] = test_run_row[0]
  row[7] = test_run_row[2]
end

def write_csv(csv, row)
  puts "new row for writing is " + row.inspect
  csv << row
end

requirements = Dir["/Users/stuart1/Downloads/issues-45.csv"]
test_features =  Dir["/Users/stuart1/Downloads/issues-49.csv"]
test_case =  Dir["/Users/stuart1/Downloads/issues-47.csv"]
test_run =  Dir["/Users/stuart1/Downloads/issues-48.csv"]

requirements_contents = requirements.map { |f| CSV.read(f) }
test_feature_contents = test_features.map { |f| CSV.read(f) }
test_case_contents = test_case.map { |f| CSV.read(f) }
test_run_instance = test_run.map { |f| CSV.read(f) }

mkdir
csv_string = CSV.generate do |csv|
  csv << csv_headers
  requirements_contents.each do |file|
    file.shift                  # remove the headers of each file
    file.each do |row|
      test_feature_contents.each do |feature|
 #       feature.shift
        puts "new req is " + row[0] + "feature contents size is " + feature.inspect
        no_test_feature = true
        feature.each do |feature_row|
          puts "in feature req is " + row[0] + " this feature related field is " + feature_row[4]
          feature_related_to = feature_row[4].gsub("Related to #", "")
          if feature_related_to === row[0]     # match the feature related to with req id
            puts "match in feature " + row[0]
            add_test_feature(row, feature_row)

            no_test_feature = false
            test_case_contents.each do |cases|
#              cases.shift
              no_test_case = true
              cases.each do |case_row|
                if case_row[4] === feature_row[0]       # match the case related to with feature id
                  add_test_case(row, case_row)
                  no_test_case = false
                  test_run_instance.each do |test_instance|
#                    test_instance.shift
                    no_test_run = true
                    test_instance.each do |test_run_row|      # may be 0 to many test runs
                      if test_run_row[5] ===  case_row[0]     # match the test run related to with case id
                        add_test_run(row, test_run_row)
                        write_csv(csv, row)       # this would write out 0 to many test run
                        no_test_run = false
                      end
                    end
                    if no_test_run
                      write_csv(csv, row)       # this would write out 0 test case
                    end
                  end
                end
              end
              if no_test_case
                write_csv(csv, row)       # this would write out 0 test case
              end
            end
          end
        end
        if no_test_feature
          write_csv(csv, row)       # this would write out 0 test features
        end
      end
    end
  end
end

File.open('traceability.csv', 'w') { |f| f << csv_string }