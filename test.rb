#!/usr/bin/env ruby
require 'nokogiri'

puts 'opening file...'
File.open('./web/www.nscb.gov.ph/listreg.asp.html') do |file|
  puts 'Parsing using Nokogiri...'
  html = Nokogiri::HTML(file)
  
  puts 'Searching by CSS...'
  html.css('p.headline a').each do |a|
    href = a['href']
    id = href[/=(\d+)$/, 1]
    s = a/:strong
    name = s[0].text
    puts "#{name} => #{href} (#{id})"
  end
end
