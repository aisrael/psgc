require 'uri'
require 'digest/md5'

module PSGC
  module Import
    # Base class for all other importers
    class Base < Struct.new :src

      WEB_FOLDER = File.expand_path(File.join(%w(.. .. .. web)), __FILE__)

      @uri = URI('http://www.nscb.gov.ph/activestats/psgc/')
      @dir = File.join(WEB_FOLDER, @uri.host)
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
          'listreg.asp' => '313c3a3d9af1ad92ff1dc9657a74a4b2',
          'province.asp?provCode=012800000' => 'e2f9cbd34a9324641bf7def58239d604',
          'province.asp?provCode=012900000' => '7accfbd2784b0faf1946b9af4f4382dd',
          'province.asp?provCode=013300000' => '453fe2bb4e9148ec0354d53d0fdc952e',
          'province.asp?provCode=015500000' => '1841f28876b2d43dd99618bbb7c2ace7',
          'province.asp?provCode=020900000' => 'acb903ec0d03743f8fcca2f2413bbf7f',
          'province.asp?provCode=021500000' => 'a5a4fb7382ca0f732000c9aac115ae70',
          'province.asp?provCode=023100000' => 'c112d9250bfd946281e5baa2cb2e9a56',
          'province.asp?provCode=025000000' => '2edcfcbfc8b0b4d973e40a37a1771949',
          'province.asp?provCode=025700000' => '122388632688b4d9bff75a6791a688c2',
          'province.asp?provCode=030800000' => '1dea8bf85291e1012f8bcc388bb89632',
          'province.asp?provCode=031400000' => '9a30f8b7a642547ac215fef6aa7193ac',
          'province.asp?provCode=034900000' => 'bbd5a0ae0e88e8e31e4271bc67dee9b0',
          'province.asp?provCode=035400000' => '079b4c14a4241685b67a6a54b4990c1a',
          'province.asp?provCode=036900000' => '440902699b54ae8b2ee8ee85b91b9f62',
          'province.asp?provCode=037100000' => '5b4acaf458a14497088c1ad84a3350ed',
          'province.asp?provCode=037700000' => '4d2c19bf06e49323acf15f1c5e14e8eb',
          'province.asp?provCode=041000000' => '351f4105f3d1a940b0936d0d9f17d69e',
          'province.asp?provCode=042100000' => '65657fec890e8bda407961e420486ab7',
          'province.asp?provCode=043400000' => '3809bbe28c4cf0bf79138710dce37259',
          'province.asp?provCode=045600000' => '9b138b22ba0e3dc3942d5291ed55b2aa',
          'province.asp?provCode=045800000' => '9eebb1358acc82488ba6d15be048ce8b',
          'province.asp?provCode=050500000' => 'b88ae48d760abf68a147a56b704d357f',
          'province.asp?provCode=051600000' => 'df40ac8be45a9c3c8c914588cad08d68',
          'province.asp?provCode=051700000' => '98b5ed9713be5e2260c596493c569525',
          'province.asp?provCode=052000000' => '98daf631246d115250873f4beb7bd430',
          'province.asp?provCode=054100000' => 'bfa359626d7f5b28c419a32a281fb715',
          'province.asp?provCode=056200000' => '55fe173f154a5b361b5e4a0755be90bf',
          'province.asp?provCode=060400000' => 'e24e4772acf06aa5a45cb287edf17085',
          'province.asp?provCode=060600000' => 'd388dbd2f2fef305511a9318ad11c239',
          'province.asp?provCode=061900000' => '5018bb09603a2b348dfdf4f1ea34ff58',
          'province.asp?provCode=063000000' => 'd006ec172d821886e794a8d2db7baf1a',
          'province.asp?provCode=064500000' => 'dbe994da7f360c61d83fa653e68a7081',
          'province.asp?provCode=067900000' => '1741abe39552b290767ae5b46555d7d4',
          'province.asp?provCode=071200000' => 'f3370d0407a43f1fa3a7dfa11b9cf1f0',
          'province.asp?provCode=072200000' => '49b29dd544daa4f2fcaf949947b870ef',
          'province.asp?provCode=074600000' => 'a8037f1ff029b98cf3bb33f48f6170dc',
          'province.asp?provCode=076100000' => '73d26f0d7119e66e8fc109fa738672b8',
          'province.asp?provCode=082600000' => '1f833e493972e8e1751df3687e990107',
          'province.asp?provCode=083700000' => '9fbcc12ee37d838d5a40d265df136568',
          'province.asp?provCode=084800000' => 'ccc1d4a0599abf59306e4c948465fd00',
          'province.asp?provCode=086000000' => '49f5d883e6b882db7afc07411ff9a07e',
          'province.asp?provCode=086400000' => 'b350407e4829779c0aa86293c0f189a9',
          'province.asp?provCode=087800000' => '8202f798e40e7628194e5f5ed2676530',
          'province.asp?provCode=097200000' => '66a51355dd3f45bb8f9cbe1eb3695800',
          'province.asp?provCode=097300000' => '3a985ae1bfbacabea13cdb76f33d1897',
          'province.asp?provCode=098300000' => '655b479afe7bca294c676eb6c1cd5338',
          'province.asp?provCode=099700000' => '54080cd2636260f4e31fb56f9c373960',
          'province.asp?provCode=101300000' => '9a11c2129a00bb9bb1031838b1612555',
          'province.asp?provCode=101800000' => '22867ddfd9bbad2cb49064a42bc92440',
          'province.asp?provCode=103500000' => 'f352c9dafbbe4688da89471f83ca80d6',
          'province.asp?provCode=104200000' => '60c4b3b3c6329f90e39cd8ebac83b19e',
          'province.asp?provCode=104300000' => 'e8df2c875279e7d0ee712ea987923c6c',
          'province.asp?provCode=112300000' => 'f752c3620c1b9260de732666816b568a',
          'province.asp?provCode=112400000' => '30efbed9e09e46e893a856958193f660',
          'province.asp?provCode=112500000' => '41bbf897c82eb3e06a63c6034463d45b',
          'province.asp?provCode=118200000' => 'c121bbef8aee68bc70ec302dc8d9b44e',
          'province.asp?provCode=124700000' => '3fb40bde58c5787db51f5978ac102a4e',
          'province.asp?provCode=126300000' => 'ca04ab1ae14f5f1567cb94a7dba397e5',
          'province.asp?provCode=126500000' => '9c6841bcd5bf1611602629635dc2f28c',
          'province.asp?provCode=128000000' => '7931f417f0651a71e01999a071b443f3',
          'province.asp?provCode=129800000' => '0796515d5e815a856c9415ea7939a83f',
          'province.asp?provCode=133900000' => '69666d54c7b3059752585b82c23ed389',
          'province.asp?provCode=137400000' => '95e278da32addba4b6534fdf723ca9f7',
          'province.asp?provCode=137500000' => '5ac4f4015b2d079b28396215900588e4',
          'province.asp?provCode=137600000' => '05f8fd554c995630c13255c97bb2d4fb',
          'province.asp?provCode=140100000' => '933f99c1c832413271bc60fbbf847641',
          'province.asp?provCode=141100000' => '0798248c7adf827fc6e5bd18d28e566d',
          'province.asp?provCode=142700000' => '2255298bbf6c2416cd65a486265ad78f',
          'province.asp?provCode=143200000' => '0f76b43980067d144b9d43962b144a0d',
          'province.asp?provCode=144400000' => '75e6ec6e61128630fce24a1be25c6fb4',
          'province.asp?provCode=148100000' => '547d3322075a02848ba424dab3230283',
          'province.asp?provCode=150700000' => 'd4f99c465b72587eb06dfa28952201d6',
          'province.asp?provCode=153600000' => '1f238883c85b04e91ef27280001fd906',
          'province.asp?provCode=153800000' => 'c459e15de776d0f2999ddffae2688c40',
          'province.asp?provCode=156600000' => '4cae2a10271da13b9d486dd06f8af230',
          'province.asp?provCode=157000000' => 'c10e1b79ed17f0c0e8742b61a5c6a1d9',
          'province.asp?provCode=160200000' => '30a947616522340c825c9eec056b10d7',
          'province.asp?provCode=160300000' => '0987f67ad803215287dcfcdd9cdfb27a',
          'province.asp?provCode=166700000' => '8c3320b4f6dbc5be502d9a86cd9209e0',
          'province.asp?provCode=166800000' => '65ca159b0482de7cda4191ada49aadf5',
          'province.asp?provCode=168500000' => '5bfe85816c6ed938894ec36a13fe7cab',
          'province.asp?provCode=174000000' => '15d17adfc18b2404782e4f9ced92770f',
          'province.asp?provCode=175100000' => '0fcaf222f546e0a678fc0f3c8121b118',
          'province.asp?provCode=175200000' => '8735542589c9898dfaf0ec5290e86038',
          'province.asp?provCode=175300000' => '9845fa3a1a4d145c7592190f6e829ccb',
          'province.asp?provCode=175900000' => '1102e8aa2d8f80ef91dec81547a09ad4',
          'regview.asp?region=01' => '7a0499021ab2b5a52b30bb8b8f5f2e9e',
          'regview.asp?region=02' => '6ceaada45e7a81b17b513644b159e3ac',
          'regview.asp?region=03' => '21b7fc30c6220a6ab3b93480489c7613',
          'regview.asp?region=04' => '712689f2f6421c2a09acd839715e6ccc',
          'regview.asp?region=05' => 'e39ced21c9fdfa11c2b04782a1872d76',
          'regview.asp?region=06' => '21abe3e5153a05e9402c064828bf2c6f',
          'regview.asp?region=07' => '6efaa3fe6ff752ab2472286bfe382ace',
          'regview.asp?region=08' => '84fee40a83b0f7a8641c87b32e0f8bf7',
          'regview.asp?region=09' => 'ab60b476d6c9bd9e7d8a390a58193b48',
          'regview.asp?region=10' => 'dfddd33c6346378f274c8e478a293773',
          'regview.asp?region=11' => '7006aa7c033ce24a18c73a95fbb59cbe',
          'regview.asp?region=12' => 'f4005b112b15e80b1ad0a0f685448c5d',
          'regview.asp?region=13' => '51395d389c09c0593f9c2f6b03016580',
          'regview.asp?region=14' => '3f483229fbad7595fa4edcc8d8acb6d6',
          'regview.asp?region=15' => '04dc9f624f81647588d2da34c718b10f',
          'regview.asp?region=16' => '314f06259eb574a73cc678079a7e9405',
          'regview.asp?region=17' => 'de297ffbb79cb546cc63b54a3bfa0949'
        }


      class << self

        def fetch(src)
          full_source = URI.join(Base.uri, src)
          target = File.join(Base.dir, src)
          if already_there(src)
            puts "#{src} already exists and matches expected hash, skipping"
          else
            puts "#{src} exists but doesn't match expected hash" if File.exists?(src)
            cmd("curl #{full_source} > #{target}")
          end
        end

        # Check if file exists and its MD5 hash equals expected_md5, if present
        def already_there(src)
          file = File.join(Base.dir, src)
          File.exists?(file) and (!CHECKSUMS.key?(src) or Digest::MD5.file(file).hexdigest == CHECKSUMS[src])
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
