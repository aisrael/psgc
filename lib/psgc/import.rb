require 'uri'
require 'digest/md5'

module PSGC
  module Import
    # Base class for all other importers
    class Base < Struct.new :src
      @uri = URI('http://www.nscb.gov.ph/activestats/psgc/')
      @dir = File.expand_path(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'web', @uri.host)))
      class << self
        attr_accessor :dir
        attr_reader :uri
        def uri=(uri)
          @uri = uri.is_a?(URI) ? uri : URI(uri)
        end
      end

      # Use `curl` to get the desired page
      def fetch
        DownloadManager.fetch(src)
        parse
      end

      # noop
      def parse
      end
      
      protected
      
      def target
        @target ||= File.join(Base.dir, src)
      end

    end

    # Responsible for fetching and caching pages
    class DownloadManager
      
      CHECKSUMS = {
        'listreg.asp' => '55349b2c7e24a01cf5a37673ada5b0f1',
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
      
      class << self

        def fetch(src)          
          full_source = URI.join(Base.uri, src)
          target = File.join(Base.dir, src)
          if already_there(src)
            puts "#{target} already exists and matches expected hash, skipping"
          else
            cmd("curl #{full_source} > #{target}")
          end
        end
  
        # Check if file exists and its MD5 hash equals expected_md5, if present
        def already_there(src)
          file = File.join(Base.dir, src)
          expected_md5 = CHECKSUMS[src]
          File.exists?(file) and !expected_md5.nil? and Digest::MD5.file(file).hexdigest == expected_md5
        end
  
        # Shortcut for:
        #
        #     puts(cmd); system(cmd)
        #
        def cmd(cmd)
          puts cmd
          system cmd
        end

      end
    end
  end
end

require 'psgc/import/import_regions'
