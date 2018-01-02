require 'json'
require 'uri'

def extractTicketNo(feature)

  uri = URI.extract(feature)

  raise "an error has occurred" if uri.length > 1

  uriElements = uri.first.split('/')

  uriElements.last.to_s.gsub(/["']/, '')

end

cucumberReport = File.read('cucumberReport/cucumber.json')
features = []

File.open("cucumberResults.json","w") do |result|
  JSON.parse(cucumberReport).each do |feature|
     passed = 0
     failed = 0
     notRun = 0

     ticketNo = extractTicketNo(feature["description"])

    feature['elements'].each do |element|
      element["steps"].each do |step|

        case step['result']['status']
          when "passed"
            passed += 1
          when "failed"
            failed += 1
          else
            notRun += 1
        end

      end
    end
    features << {:feature => ticketNo, :results => {:passed => passed, :failed => failed, :notRun => notRun}}
  end
  result.write((JSON.pretty_generate(features)))
end
