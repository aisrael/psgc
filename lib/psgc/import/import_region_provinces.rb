require 'nokogiri'
require 'fileutils'

require_relative 'import_province_municipalities'

module PSGC
  module Import
    # Import Region List
    class ImportRegionProvinces < Base

      attr_reader :region_id

      def initialize(region_id, src)
        super(src)
        @region_id = region_id
      end

      def parse
        parser = Parser.new
        File.open(full_target) do |input|
          parser.parse Nokogiri::HTML(input)
        end
        dir = File.join(PSGC::DATA_DIR, @region_id)
        FileUtils.mkdir_p dir
        header = %w(id name)
        CSV.open(File.join(dir, 'provinces.csv'), 'w') do |out|
          out << header
          parser.provinces.each {|province| out << province }
        end
        parser.hrefs.each do |province_id, href|
          ipm = ImportProvinceMunicipalities.new province_id, href
          ipm.fetch
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
              id = tds[1].text[0, 4]
              @provinces << [id, name]
              @hrefs[id] = "province.asp?provCode=#{id}00000"
            end
          end
        end
      end
    end
  end
end
