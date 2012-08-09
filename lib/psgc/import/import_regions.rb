require 'nokogiri'

module PSGC
  module Import
    # Import Region List
    class ImportRegions < Base
      def initialize
        super 'listreg.asp', '55349b2c7e24a01cf5a37673ada5b0f1'
      end
      
      def parse
        parser = Parser.new
        File.open(target) do |input|
          parser.parse Nokogiri::HTML(input)
        end
        File.open(PSGC::Region::REGION_DATA, 'w') do |out|
          out << YAML::dump_stream(*parser.regions)          
        end
      end
      
      class Parser
        
        attr_reader :regions
        
        def initialize
          @regions = []
        end
        
        def parse(html)
          html.css('table.table4').each do |table|
            parse_table(table)
          end
        end
        
        def parse_table(table)
          td = table/:td
          if (td.size == 2)
            p = td[0]/:p
            href = (p/:a)[0]['href']
            id = href[/=(\d+)$/, 1]
            name = (p/:strong).text
            t = (td[1]).text.split.join # removes newlines and extra whitespace
            code = t[/Code:(.*)$/, 1].strip
            puts "(#{id}) #{code} #{name} => #{href}"
            @regions << {'id' => id, 'code' => code, 'name' => name }
          end
        end
      end
    end
  end
end
