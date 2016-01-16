#! /usr/bin/ruby

# You can download the airports.csv file from
# the following website:
#
# http://ourairports.com/data

require 'colorize'
require 'plist'

stations = {}

def clean(text)
  text.delete('\\"')
end

puts 'Parsing the icao.csv file...'.white
file = File.open('./scripts/ICAO.csv')
file.each_with_index do |line, index|
  next if index == 0
  fields = line.split(',')
  stations[clean(fields[1])] = {
    name: clean(fields[3]),
    country: clean(fields[8])
  }
end

puts 'Parsing the data to the plist...'.white
plist_path = './Metar/Supporting Files/Data/ICAO.plist'
plist_content = stations.to_plist
File.write(plist_path, plist_content)

puts 'ICAO.plist file written to disk.'.green
