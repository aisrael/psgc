require 'csv'

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
        header = %w(id name)
        CSV.open(PSGC::Region::REGION_DATA, 'w') do |out|
          out << header
          parser.regions.each {|region| out << region }
        end
        parser.hrefs.each do |id, href|
          irp = ImportRegionProvinces.new id, href
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
            @regions << [id, name]
            @hrefs[id] = href
          end
        end
      end
    end
  end
end
