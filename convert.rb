require 'date'
require 'json'

# FUNCTIONS
def empty_line?(str)
  str.match /^$/
end

def time_to_epoch(time_str)
  DateTime.parse("2016-01-01 #{time_str}").to_time.to_i
end

def split_line(str)
   str.match(/(\d{1,}:\d{1,}:\d{1,}) (.*)/).to_a[1..-1]
end

# IMPLEMENTATION
file_path = ARGV[0]
file_contents = File.read(ARGV[0])
data = {
  title: File.basename(file_path, '.*'),
  startDate: nil,
  ratings: []
}
file_contents.each_line do |line|
  next if empty_line?(line)
  timestamp, note = split_line(line)
  next unless timestamp && note
  if note.match /3-2-1/
    data[:startDate] = time_to_epoch(timestamp)
  else
    data[:ratings].push({
      date: time_to_epoch(timestamp),
      rating: note.encode(:xml => :text)
    })
  end
end

puts JSON.generate(data)
