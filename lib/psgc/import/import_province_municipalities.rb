require 'nokogiri'

module PSGC
  module Import
    # Import Province cities and municipalities
    class ImportProvinceMunicipalities < Base
      
      attr_reader :provice_id

      def initialize(province_id, src)
        super(src)
        @province_id = province_id
      end
      
      def parse
        parser = Parser.new
        File.open(target) do |input|
          parser.parse Nokogiri::HTML(input)
        end
        region_id = @province_id.to_s[0, 2]
        dir = File.join(PSGC::DATA_DIR, region_id, @province_id)
        FileUtils.mkdir_p dir
        File.open(File.join(dir, 'cities.yml'), 'w') do |out|
          parser.cities.each { |city|
            out << YAML::dump_stream(city)
          }
        end
      end
      
      class Parser
        
        attr_reader :cities, :municipalities, :hrefs
        
        def initialize
          @cities = []
          @municipalities = []
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
          if tds.size == 9
            a = tds[0].css('p a')
            if a
              name = a.text
              href = a[0]['href']
              code = tds[1].text
              city_class = tds[3].text.gsub("\u00A0", '').strip
              city = !city_class.empty?
              puts "#{code}: #{name} => #{href} (#{city ? 'City' : 'Municipality'})"
              h = { 'id' => code, 'name' => name }
              if city
                @cities << h
              else
                @municipalities << h
              end
            end
          end
        end
      end
    end
  end
end
