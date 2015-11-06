require 'nokogiri'

module PSGC
  module Import
    # Import a city or municipality's barangays
    class ImportMunicipalityBarangays < Base

      CSV_HEADER = %w(id name urban_rural population)

      attr_reader :municipality_id

      def initialize(municipality_id, src)
        super(src)
        @municipality_id = municipality_id
      end

      def parse
        parser = Parser.new
        File.open(full_target) do |input|
          parser.parse Nokogiri::HTML(input)
        end

        # mkdir
        region_dir = @municipality_id.to_s[0, 2]
        province_dir = @municipality_id.to_s[0, 4]
        dir = File.join(PSGC::DATA_DIR, region_dir, province_dir)
        FileUtils.mkdir_p dir

        # barangays.csv
        unless parser.barangays.empty?
          CSV.open(File.join(dir, "#{municipality_id}.csv"), 'w') do |out|
            out << CSV_HEADER
            parser.barangays.each { |barangay| out << barangay }
          end
        end

      end

      class Parser

        attr_reader :barangays

        def initialize
          @barangays = []
        end

        def parse(html)
          html.css('table').each do |table|
            rows = table/:tr
            if rows.count == 1
              parse_row(rows[0]) if rows.count == 1
            end
          end
        end

        def parse_row(tr)
          tds = tr/:td
          if tds.size == 4
            name = tds[0].text
            code = tds[1].text
            urban_rural = tds[2].text.strip
            population = tds[3].text.gsub(',', '')
            barangays << [code, name, urban_rural, population]
          end
        end
      end
    end
  end
end
