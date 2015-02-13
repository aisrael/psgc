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
          'listreg.asp' => '6b7d209599cee11903dec773beaa7501',
          'province.asp?provCode=012800000' => 'c73df0ea2a5d671029d390881beb263a',
          'province.asp?provCode=012900000' => 'a4fd4f4a64cba60248829638628730d7',
          'province.asp?provCode=013300000' => '0d9440f10cd2dc11f0ea404e993fc083',
          'province.asp?provCode=015500000' => '6aa56069623798687ed415759bd0769c',
          'province.asp?provCode=020900000' => '1dccbf23282f8efd5a402837f5617ec0',
          'province.asp?provCode=021500000' => '72ab8cfc5c7e1f278a8ca30a1b1ca618',
          'province.asp?provCode=023100000' => 'cfd43c6436b8472ddfff8d370696d804',
          'province.asp?provCode=025000000' => 'b32c1684f3e87a0d8c09b831150f7dec',
          'province.asp?provCode=025700000' => '7a3cfb1e6c86373eb779c095eb2ae395',
          'province.asp?provCode=030800000' => 'ff3a9af3076e8dd6ce74b42183c8fffe',
          'province.asp?provCode=031400000' => '9c2e184148bf5968d99cb0183c8c952c',
          'province.asp?provCode=034900000' => 'a826476a00287274dcd2eea39b8832b6',
          'province.asp?provCode=035400000' => 'e9018ab73a098e4dbd854dd2408607f4',
          'province.asp?provCode=036900000' => 'aa544058e4ef9b34f3f63135545a5a8d',
          'province.asp?provCode=037100000' => 'e54e86a88e75ff7ca895eed181a0f417',
          'province.asp?provCode=037700000' => 'bb4b56f243547d31853a4b73251ddbe9',
          'province.asp?provCode=041000000' => '4cc59fa13c934b1d4bfb49e6c87be90a',
          'province.asp?provCode=042100000' => 'aa2743f93f1b261ce653be730c73ad9a',
          'province.asp?provCode=043400000' => '3598d1219203ba4a73ee9b984908a942',
          'province.asp?provCode=045600000' => 'b340ca3d5850c5ca80e7d324be4ca662',
          'province.asp?provCode=045800000' => '802129440892241ed27e2cc6486ada90',
          'province.asp?provCode=050500000' => '5234d17e81f02a9bbb8af51d11179c7a',
          'province.asp?provCode=051600000' => '0aae9df6fe67d2c52e4ec0db44603603',
          'province.asp?provCode=051700000' => '5a997481eccc655d94a39a1a86d8e131',
          'province.asp?provCode=052000000' => '7f5ad2052a6fd50f58119de2bd62fef8',
          'province.asp?provCode=054100000' => '426128b4db1e72a88557558392ccb633',
          'province.asp?provCode=056200000' => '70b87d3aff1a88beb2a67d359798472c',
          'province.asp?provCode=060400000' => 'a74407d6c6e9315f856b6bbfa0d9388b',
          'province.asp?provCode=060600000' => '22237182759de6d446e335719b93e2ad',
          'province.asp?provCode=061900000' => '76a3ed79d4004b4076daf20160730a29',
          'province.asp?provCode=063000000' => '41b01d5dada2be0c8c5b397a22a2867a',
          'province.asp?provCode=064500000' => '46bf65a22e8e621b06daf52d3678b163',
          'province.asp?provCode=067900000' => '18fa5e0d50fad332cd5455f5a9bb1546',
          'province.asp?provCode=071200000' => '90ba92250d4d342b254fd78ea799dc26',
          'province.asp?provCode=072200000' => 'caf5f0b8590caa92c8132d8a291068ab',
          'province.asp?provCode=074600000' => '2709e3105350bdc594fa35ff19559ebc',
          'province.asp?provCode=076100000' => 'db9c57e973d3ad7637363c8af8eae9db',
          'province.asp?provCode=082600000' => '6759f7356286bf81750a10122fd1a9f1',
          'province.asp?provCode=083700000' => '6c6e4291668938d921c75c56b4508e0b',
          'province.asp?provCode=084800000' => 'b1daf14909a9611b5feb1c43b232a1fe',
          'province.asp?provCode=086000000' => '0c60f3f199dfbdc436982fc2d83e4aa4',
          'province.asp?provCode=086400000' => '27b1b6820348d176c0d7552f0786c68c',
          'province.asp?provCode=087800000' => '302595b1e05e311bcd8805cc34c6a4d9',
          'province.asp?provCode=097200000' => 'ccbce2ba4edcb18535231aecbe1c649d',
          'province.asp?provCode=097300000' => '766871e71f9f7b6d34c9619f53656648',
          'province.asp?provCode=098300000' => '56f1b32b2be9c25d6bb120647e95d13d',
          'province.asp?provCode=099700000' => '336662b084d22f4857d8720181f29c85',
          'province.asp?provCode=101300000' => '40016690fa2c21a1643841a560f64a12',
          'province.asp?provCode=101800000' => 'd5fc8f434ab695bf13dd817b0dabca11',
          'province.asp?provCode=103500000' => '249917c53ba79320f4afebdcd0443d47',
          'province.asp?provCode=104200000' => '044383ab288f6cbc2ebb708b217fc77c',
          'province.asp?provCode=104300000' => 'e750421dba3fda0ba2ca9ab82c4234d5',
          'province.asp?provCode=112300000' => '722bf1568223dd9859c3b82d87b173a8',
          'province.asp?provCode=112400000' => 'd88d972fba2c0eab72c1f79e68ce21aa',
          'province.asp?provCode=112500000' => '2bafe22e3a49f396402df9a9e0373c2e',
          'province.asp?provCode=118200000' => 'b85679530969f3988e18cb9892c0146d',
          'province.asp?provCode=118600000' => '8bd62ce41db670f33281a4323e044475',
          'province.asp?provCode=124700000' => '3e501f2da0be7fbc04bc498f859e90af',
          'province.asp?provCode=126300000' => '171901488f5369cf8eacf21ea901d928',
          'province.asp?provCode=126500000' => 'a8a2923169d6dca9e467cfcb0ce559bb',
          'province.asp?provCode=128000000' => 'e3187d429d88874e8c5e8f2e2a4be376',
          'province.asp?provCode=129800000' => '7488cc147fe96d40eb59eb78a52c89c7',
          'province.asp?provCode=133900000' => 'd1ed92ba3295704aefc150ae2c1222f6',
          'province.asp?provCode=137400000' => '5c9940ebe0d4210624425eec9e746ca5',
          'province.asp?provCode=137500000' => 'dd10ede30008ac99c9cdc923ac9ddb61',
          'province.asp?provCode=137600000' => 'fa793bee4db334ba5abc461da25c508a',
          'province.asp?provCode=140100000' => '8106efd4b012a519e2137f70fcb58e8e',
          'province.asp?provCode=141100000' => '69b878c98da7fc969005dc18c02e55c4',
          'province.asp?provCode=142700000' => '60d1ed1857ee64266a2e55a7c27d7499',
          'province.asp?provCode=143200000' => '6783b58bfa1acb79db1bcb34a947145c',
          'province.asp?provCode=144400000' => 'd42b53fbcb029e75fbdc6a6da99f464e',
          'province.asp?provCode=148100000' => '6fae50f1d1342d65b811b78f2e821fed',
          'province.asp?provCode=150700000' => '96d1be8b2326295ce1a3ea7a93dcda61',
          'province.asp?provCode=153600000' => 'aad4a7fe7b38b93a00bb10fab5b2a9c2',
          'province.asp?provCode=153800000' => 'cbba8e7823c1acef904f51b29a9a43f3',
          'province.asp?provCode=156600000' => '91c19001183d345b0bfc3abe308942cb',
          'province.asp?provCode=157000000' => '637eeec3f3963e6dd1deed00807a6ee4',
          'province.asp?provCode=160200000' => '5adf93d719932ed079f18c772328ccda',
          'province.asp?provCode=160300000' => '375ec8abd6d73958d8411b7faf69ba8b',
          'province.asp?provCode=166700000' => '3b8b6c89f52adfcf2da254d12794ca7b',
          'province.asp?provCode=166800000' => '3c2a5c13ffb2415ccd7bebae335d406f',
          'province.asp?provCode=168500000' => '56932428b7c7bead6a0b8a95237c4c64',
          'province.asp?provCode=174000000' => '584f87219ee18d8ee382a1720fcd0ff6',
          'province.asp?provCode=175100000' => 'b3c472a1486c4830aac501a6affcf05c',
          'province.asp?provCode=175200000' => '714eab451c52747980e9c36301853ac7',
          'province.asp?provCode=175300000' => '66fe8607b7071e4960d6f42d7f3a2f0c',
          'province.asp?provCode=175900000' => '382c0f8c93d26742515d569418a266de',
          'regview.asp?region=01' => '6f375855220f6b03323a68ecd6d65ce8',
          'regview.asp?region=02' => '9af83a838f4a160f7a8424854b12a6c3',
          'regview.asp?region=03' => '04e6d33703548363d3b3ba1ada858bac',
          'regview.asp?region=04' => '1f175970d91972d5198bfb15e847f121',
          'regview.asp?region=05' => 'ffd17978e8860ae33f9db5be618156c5',
          'regview.asp?region=06' => '1233de5496a890bd34835b706be4c18d',
          'regview.asp?region=07' => '66f99ae4acbd24eb842fa68ee4182c55',
          'regview.asp?region=08' => 'a0ef04037b2c2497f2453b0b5b4e3a65',
          'regview.asp?region=09' => 'b0ee9520de6f7d9b104eb5f5ec4fc0f3',
          'regview.asp?region=10' => '40afb8955631b2eba565cbff9e050add',
          'regview.asp?region=11' => '20d24ec24e4c3cf8bbb090718ba4878f',
          'regview.asp?region=12' => '65c3a0d546a78be45e0ca811b45e583c',
          'regview.asp?region=13' => '91bee37bd952a1d4ae432b8810c68ec3',
          'regview.asp?region=14' => '39341484d70f972f2d3279cd1d87d2cd',
          'regview.asp?region=15' => 'fe2eea869eb978b83735b3573af19576',
          'regview.asp?region=16' => '398f186ae2ff0ec99f74678b3386f66f',
          'regview.asp?region=17' => 'd47ff4f7693dab2a7369827007dc13d1'
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
