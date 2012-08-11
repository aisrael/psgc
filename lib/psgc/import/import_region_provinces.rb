require 'nokogiri'
require 'fileutils'

module PSGC
  module Import
    # Import Region List
    class ImportRegionProvinces < Base
      
      EXPECTED_HASHES = {
        'regview.asp?region=01' => '5d5bf4a4847c97e7a974002982ea395f',
        'regview.asp?region=02' => '3f1255ca409b4edcb41cb8b7c9d5e17f',
        'regview.asp?region=03' => 'b3ef32491d67bf244f3d2e82f0ac4d50',
        'regview.asp?region=04' => '03763a8bc8a680d42b3801240496ea18',
        'regview.asp?region=05' => '2ddd7fccec8cebad970e99bc58ef7882',
        'regview.asp?region=06' => 'c206a7378b4040a664d167e7dbba142e',
        'regview.asp?region=07' => '6c078395d2eccd792aa0942a5f922681',
        'regview.asp?region=08' => '1a44da9af998c2f80aa7e81e542d8b2e',
        'regview.asp?region=09' => 'fc048d13120080c3ae1b1ce08a0da007',
        'regview.asp?region=10' => 'c2a275be470c47973f72a1b4343fa4b7',
        'regview.asp?region=11' => '929f07bc3f170492fe0df3fc8c57a636',
        'regview.asp?region=12' => '8ee8020103b744c682700072b92dffa1',
        'regview.asp?region=13' => 'da40d53889f7c3335e11cb0529c1179e',
        'regview.asp?region=14' => '88b1a693a3236cf4142a205401a1cda3',
        'regview.asp?region=15' => 'ff50e60c59d4b912d2330c0ab1387bfb',
        'regview.asp?region=16' => '6f8bae6b2ddfaee4ac586b324252277a',
        'regview.asp?region=17' => '46ec0e415d07ed9254855b5c0a369381'
      }

      attr_reader :region_id, :href

      def initialize(region_id, href, md5)
        super(href, md5)
        @region_id = region_id
        @href = href
      end
      
      def parse
        parser = Parser.new
        File.open(target) do |input|
          parser.parse Nokogiri::HTML(input)
        end
        dir = File.join(PSGC::DATA_DIR, @region_id)
        FileUtils.mkdir_p dir
        File.open(File.join(dir, 'provinces.yml'), 'w') do |out|
          parser.provinces.each { |province|
            out << YAML::dump_stream(province)
          }
        end
        parser.hrefs.each do |province_id, href|
          puts "#{province_id} => #{href}"
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
              @provinces << { 'id' => id, 'name' => name}
              @hrefs[id] = href
            end
          end
        end
      end
    end
  end
end
