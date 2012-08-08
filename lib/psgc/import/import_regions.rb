require 'nokogiri'

module PSGC
  module Import
    # Import Region List
    class ImportRegions < Base
      def initialize
        super 'listreg.asp', '55349b2c7e24a01cf5a37673ada5b0f1'
      end
      
      def parse
        regions = []
        File.open(target) do |input|
          html = Nokogiri::HTML(input)
          html.css('p.headline a').each do |a|
            href = a['href']
            id = href[/=(\d+)$/, 1]
            s = a/:strong
            name = s[0].text
            regions << {'id' => id, 'name' => name }
            puts "#{name} => #{href} (#{id})"
          end
        end
        File.open(PSGC::Region::REGION_DATA, 'w') do |out|
          out << YAML::dump_stream(*regions)          
        end
      end
    end
  end
end
