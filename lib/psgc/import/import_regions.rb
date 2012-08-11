require 'nokogiri'

require_relative 'import_region_provinces'

module PSGC
  module Import
    # Import Region List
    class ImportRegions < Base
      def initialize
        super 'listreg.asp'
      end
      
      def parse
        parser = Parser.new
        File.open(target) do |input|
          parser.parse Nokogiri::HTML(input)
        end
        File.open(PSGC::Region::REGION_DATA, 'w') do |out|
          out << YAML::dump_stream(*parser.regions)   
        end
        parser.hrefs.each do |id, href|
          md5 = ImportRegionProvinces::EXPECTED_HASHES[href]
          irp = ImportRegionProvinces.new id, href, md5
          irp.fetch
        end
      end
      
      class Parser
        
        attr_reader :regions, :hrefs
        
        def initialize
          @regions = []
          @hrefs = {}
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
            @regions << {'id' => id, 'name' => name }
            @hrefs[id] = href
          end
        end
      end
    end
  end
end
