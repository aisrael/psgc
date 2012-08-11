require 'uri'
require 'digest/md5'

module PSGC
  module Import
    # Base class for all other importers
    class Base < Struct.new :src
      @uri = URI('http://www.nscb.gov.ph/activestats/psgc/')
      @dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'web', @uri.host))
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
        'listcity.asp' => 'cb755ef43f6e2acc9322caccc08dd03e',
        'listprov.asp' => '8efb9d44b4f0d585277837ede9af46e3',
        'listreg.asp' => '55349b2c7e24a01cf5a37673ada5b0f1',
        'province.asp?provCode=012800000' => 'ec2cc935cf376c1a38446e5383b1d296',
        'province.asp?provCode=012900000' => 'f4227ddd1b380834540cf84915b01e7f',
        'province.asp?provCode=013300000' => '38925ccc2f0d111ed0a862cd8ff6a02c',
        'province.asp?provCode=015500000' => 'bd0ad0196e79af8d42249e3ab0e6d705',
        'province.asp?provCode=020900000' => '613da1a4b2b8a0c8d37c39daef4f7194',
        'province.asp?provCode=021500000' => '770fdc08b0a3514340bd4a43397e7934',
        'province.asp?provCode=023100000' => '8ff32feb4ebf0bfa8b09503319931a00',
        'province.asp?provCode=025000000' => '8a3bdb64a2fda2acbcaec69916b80b16',
        'province.asp?provCode=025700000' => 'ceb8decb9c235b573ae418e7da37bcc3',
        'province.asp?provCode=030800000' => '3d0652a5e2b60ed96d244f63b4661fc4',
        'province.asp?provCode=031400000' => 'd84061b5d80710d4a88ddd83b812ce59',
        'province.asp?provCode=034900000' => '09aaa7827fc64ee87edb9c6faeb10473',
        'province.asp?provCode=035400000' => '4fa0733c25836a52f610a2d7e0063f15',
        'province.asp?provCode=036900000' => 'eb88b764b63408b5a6141880583cb95e',
        'province.asp?provCode=037100000' => 'b06466065bcacaf3f5297b6d8d37b716',
        'province.asp?provCode=037700000' => '3ccae3f710a4bc8e6859d3994da687ba',
        'province.asp?provCode=041000000' => '5f7bd8fe20e72172fd3a659dc9ecdabd',
        'province.asp?provCode=042100000' => '893de36f546005b21ffd3029bb05be9b',
        'province.asp?provCode=043400000' => '38c434284ea345dc249bb245e2f72bd1',
        'province.asp?provCode=045600000' => '75f5a5d2c68a18adf53d7275b03fef93',
        'province.asp?provCode=045800000' => '2522ce233a8f2d4f54d166b8db0a83af',
        'province.asp?provCode=050500000' => '8f4a9c6b801b70aaec85538302f5d92b',
        'province.asp?provCode=051600000' => '9a06a4056f5f1ee09ab3e1b3c6570d35',
        'province.asp?provCode=051700000' => 'd24c0f02a53287438e28cd2b2a819b23',
        'province.asp?provCode=052000000' => 'c793cb6f9c14e67dc47123abc033d589',
        'province.asp?provCode=054100000' => '041f52579577bc828b8691f97d09b31c',
        'province.asp?provCode=056200000' => '11c9974cf74eb1cba6092d75e18e867f',
        'province.asp?provCode=060400000' => 'f2baa7524ea9a75a6aa2e859368403ec',
        'province.asp?provCode=060600000' => '78a36b574ece9a54ac8d946045a98db3',
        'province.asp?provCode=061900000' => '4fe324dd9ec11eacd23ce51e188fd08c',
        'province.asp?provCode=063000000' => 'fe8a1029418f121ce419c0b7b0c92beb',
        'province.asp?provCode=064500000' => '393f00c6223e041bf457dac3d027ff75',
        'province.asp?provCode=067900000' => '41750665bd03ea073f440622906f19cc',
        'province.asp?provCode=071200000' => '492139af53c071911582a64af50bc118',
        'province.asp?provCode=072200000' => 'd2037255dd683f8d51c72ba235721a9e',
        'province.asp?provCode=074600000' => '4552d769435a8c0253b1f7a52ac270bf',
        'province.asp?provCode=076100000' => '0537620c9ea0a4aa5e48f039d51801db',
        'province.asp?provCode=082600000' => '0a3c34186c2241949943059f70460d06',
        'province.asp?provCode=083700000' => 'f99d722fb8a3bdf94e1024e513fccab6',
        'province.asp?provCode=084800000' => '795d4829f69dee3427353a63c7a697c6',
        'province.asp?provCode=086000000' => 'a7a6f8d668bcd13b19e285f95a1ef07d',
        'province.asp?provCode=086400000' => '00e4c5bc2929b3baa03767820f207c18',
        'province.asp?provCode=087800000' => '166615b66e016849a96b377114edb008',
        'province.asp?provCode=097200000' => 'f03f178915812f57e1d21ae4761079c1',
        'province.asp?provCode=097300000' => '355da28f702e269174810a059b629fd5',
        'province.asp?provCode=098300000' => '1313c35e7aefa421ddaa808b1b42418a',
        'province.asp?provCode=099700000' => 'b5bdac57e4dbad1f79cca6d10ff65078',
        'province.asp?provCode=101300000' => '1238badcbbfd0166d27d3eff135e5059',
        'province.asp?provCode=101800000' => 'b8905cdcfd17f255f9dbca3f0e77fb23',
        'province.asp?provCode=103500000' => '354204caeb08705e02f7728cff82e385',
        'province.asp?provCode=104200000' => 'c7619e7471180b12410db418da2309d7',
        'province.asp?provCode=104300000' => 'e43f3e94c6f47118a2dd0772ecf480f8',
        'province.asp?provCode=112300000' => '85a138e96be032bd80710c23a8317d6f',
        'province.asp?provCode=112400000' => '1eca63731a6908f41d04b778398e2630',
        'province.asp?provCode=112500000' => '5ffbaf7da3c30d301cf943b02d2cf0fe',
        'province.asp?provCode=118200000' => '29b16a4987aea52cffbffa2c2b4bacad',
        'province.asp?provCode=124700000' => '5092cf15ab92bb36eb42b7f046e558d1',
        'province.asp?provCode=126300000' => 'ccce6db235bec774803ed529d118f1a7',
        'province.asp?provCode=126500000' => '4798fe76759b7a0e3fc0c01c5ec7f87a',
        'province.asp?provCode=128000000' => '65348d2f07f13c0fb7eb61caeae8207a',
        'province.asp?provCode=129800000' => 'be1f9f9470644961f96696f31ad78927',
        'province.asp?provCode=133900000' => 'ccf479789e59129eab7d0eb1d38bd5d4',
        'province.asp?provCode=137400000' => '744f86eaf112b2fa432f1f21c126396a',
        'province.asp?provCode=137500000' => 'f95b2b6613ac40c3623c54baa8efaad8',
        'province.asp?provCode=137600000' => 'ebb524e39e93728a94cdf49e3bdf8db1',
        'province.asp?provCode=140100000' => 'd840f432d5460fcc1cc841a0273de03f',
        'province.asp?provCode=141100000' => '73d65d5712bd28fe685d5aabe3238c6a',
        'province.asp?provCode=142700000' => '8794dd115604c5bf4d3d83f4ffca106b',
        'province.asp?provCode=143200000' => 'd290027f8b956b5d13a3dd1637bf1aae',
        'province.asp?provCode=144400000' => '39e5db0654defd04b1e4eeff3e9b7383',
        'province.asp?provCode=148100000' => '5773adfb84e15526b205301ab45eee6b',
        'province.asp?provCode=150700000' => '649c9a5247767726f89f79b34f18824a',
        'province.asp?provCode=153600000' => '33ab400cef3ea97c057b0e7c5ee4cd09',
        'province.asp?provCode=153800000' => 'ba900706ae98b71d29f052805d389610',
        'province.asp?provCode=156600000' => '6d30b3068e10f56d9858c28506f909fc',
        'province.asp?provCode=157000000' => 'd83dd0dade2c712886518c718ff28c81',
        'province.asp?provCode=160200000' => '97b063e4efbe899858d64eae208d3f4e',
        'province.asp?provCode=160300000' => '276eb93e42c5987245c100d6a7d4f9a7',
        'province.asp?provCode=166700000' => '0bf4766b050cac6e3a2d8b16f6924a1d',
        'province.asp?provCode=166800000' => '88b194f6fd896c6550a80f9b0d0d12d1',
        'province.asp?provCode=168500000' => '984227645329c613256f4420d85da8e8',
        'province.asp?provCode=174000000' => '94276923c1869d88d88ac6446c11af93',
        'province.asp?provCode=175100000' => '1dffc6b23bc05338765d93d34514bff5',
        'province.asp?provCode=175200000' => '8d118cb71882956dcb7ea61c1916a3f9',
        'province.asp?provCode=175300000' => '9513d6dab0126334d9f68c05c9c29b91',
        'province.asp?provCode=175900000' => '3e2cf08b342e92efdb2f352fcd9603ac',
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
            puts "#{src} already exists and matches expected hash, skipping"
          else
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
