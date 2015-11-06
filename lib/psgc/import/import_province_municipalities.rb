require 'nokogiri'

require_relative 'import_municipality_barangays'

module PSGC
  module Import
    # Import Province cities and municipalities
    class ImportProvinceMunicipalities < Base

      CSV_HEADER = %w(id name)

      attr_reader :provice_id

      def initialize(province_id, src)
        super(src)
        @province_id = province_id
      end

      def parse
        parser = Parser.new
        File.open(full_target) do |input|
          parser.parse Nokogiri::HTML(input)
        end

        # mkdir
        region_dir = @province_id.to_s[0, 2]
        dir = File.join(PSGC::DATA_DIR, region_dir, @province_id)
        FileUtils.mkdir_p dir

        # cities.csv
        unless parser.cities.empty?
          CSV.open(File.join(dir, 'cities.csv'), 'w') do |out|
            out << CSV_HEADER
            parser.cities.each { |city| out << city }
          end
        end

        # municipalities.csv
        unless parser.municipalities.empty?
          CSV.open(File.join(dir, 'municipalities.csv'), 'w') do |out|
            out << CSV_HEADER
            parser.municipalities.each { |muni| out << muni }
          end
        end

        parser.hrefs.each do |municipality_id, href|
          ipm = ImportMunicipalityBarangays.new municipality_id, href
          ipm.fetch
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
          if tds.size == 8
            a = tds[0].css('p a')
            if a.count > 0
              name = a.text
              href = a[0]['href']
              code = tds[1].text
              city_class = tds[3].text.gsub("\u00A0", '').strip
              city = !city_class.empty?
              h = [code, name]
              if city
                @cities << h
              else
                @municipalities << h
              end
              @hrefs[code] = href
            end
          end
        end
      end
    end
  end
end
