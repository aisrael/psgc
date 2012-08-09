require 'nokogiri'

module PSGC
  module Import
    # Import Region List
    class ImportRegionProvinces < Base
      
      EXPECTED_HASHES = {
        '01280000' => '1f481b1c0e31e3a5ae7b11bea10247a1'
      }

      attr_reader :provice_id, :href

      def initialize(province_id, href, md5)
        super(href, md5)
        @province_id = province_id
        @href = href
      end
      
      def parse
        parser = Parser.new
        File.open(target) do |input|
          parser.parse Nokogiri::HTML(input)
        end
        File.open(PSGC::CityOrMunicipality::COM_DATA, 'w+') do |out|
          parser.coms.each { |com|
            out << YAML::dump_stream(com)
          }
        end
      end
      
      class Parser
        
        attr_reader :provinces, :hrefs
        
        def initialize
          @provinces = []
          @hrefs = {}
        end
        
        def parse(html)
          html.css('table').each do |table|
            rows = table/:tr
            parse_row(rows[0]) if rows.count == 1
          end
        end
        
        def parse_row(tr)
          tds = tr/:td
          if tds.size == 6
            a = tds[0].css('p a')
            if a
              name = a.text
              href = a[0]['href']
              code = tds[1].text
              puts "#{code}: #{name} => #{href}"
            end
            @provinces << { 'id' => code[0, 4], 'code' => code, 'name' => name}
            @hrefs[code] = href
          end
        end
      end
    end
  end
end
