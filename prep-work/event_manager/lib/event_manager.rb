require "csv"
require "sunlight/congress"
Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"
require "erb"

puts "EventManager Initialized!"

def clean_zipcode(code)
	code.to_s.rjust(5, '0')[0..4]
end
def legislators_by_zipcode(zipcode)
	Sunlight::Congress::Legislator.by_zipcode(zipcode)
end
def write_letter(letter, id)
	Dir.mkdir("output") unless Dir.exists?("output")
	File.open("output/thanks_#{id}.html", 'w') do |file|
		file.puts letter
	end
end

template = ERB.new(File.read("./template_letter.html"))
contents = CSV.open("event_attendees.csv", headers:true, header_converters: :symbol).each do |line|
	id = line[0]
	name = line[:first_name]
	zipcode = clean_zipcode(line[:zipcode])
	legislators = legislators_by_zipcode(zipcode)
	personal_letter = template.result(binding)
	write_letter(personal_letter, id)
end
