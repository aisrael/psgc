#!/usr/bin/env ruby
require 'nokogiri'

puts 'opening file...'
File.open('./web/www.nscb.gov.ph/listreg.asp.html') do |file|
  puts 'Parsing using Nokogiri...'
  html = Nokogiri::HTML(file)
  
  puts 'Searching...'
  html.css('table.table4').each do |table|
    puts "---"
    td = table/:td
    if (td.size == 2)
      p = td[0]/:p
      href = (p/:a)[0]['href']
      id = href[/=(\d+)$/, 1]
      name = (p/:strong).text
      t = (td[1]).text.split.join # removes newlines and extra whitespace
      code = t[/Code:(.*)$/, 1].strip
      puts "(#{id}) #{code} #{name} => #{href}"
    else
      puts td.text
    end
  end
end
