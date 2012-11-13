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
        'listreg.asp' => '6ae92213559abd6153a04d8796ffdc55',
        'province.asp?provCode=012800000' => '13a2c491daa419e2f1bb162f069f0566',
        'province.asp?provCode=012900000' => '8313088ac1f6585a9e2b1b6d5420685b',
        'province.asp?provCode=013300000' => '9dc5bea113674d07964c28892ea5ca59',
        'province.asp?provCode=015500000' => '5cf45af5bfc66bad48feee1d44ede745',
        'province.asp?provCode=020900000' => '62bb645bbffbfcce8ed52b442f142233',
        'province.asp?provCode=021500000' => '00b1f0d3398fe97b6e36a798dfa675ce',
        'province.asp?provCode=023100000' => 'bb970541912fcc5dfeea7f016964206c',
        'province.asp?provCode=025000000' => '7f21a8f788e611003d4a3bd071530843',
        'province.asp?provCode=025700000' => 'e26d9bb4a2a9bea87d40340d6d4c43f2',
        'province.asp?provCode=030800000' => '8b054d8bd9a716a901f422b5964703d8',
        'province.asp?provCode=031400000' => 'bc6fab657b6eefe3ead08a160cc6035a',
        'province.asp?provCode=034900000' => '43a7d14eec6b74ff2038526e1462d93d',
        'province.asp?provCode=035400000' => '88e3a29a616bab2482c5054e71eef71b',
        'province.asp?provCode=036900000' => '2c5c08c3b75c7a66bb6b7948835c1f20',
        'province.asp?provCode=037100000' => 'f209e0d0c64185d61560ffba93dc2a18',
        'province.asp?provCode=037700000' => 'ca4b896cd80163b367dc3c5ee52f00d1',
        'province.asp?provCode=041000000' => 'd435b9e32625726da7d52d857f9305f6',
        'province.asp?provCode=042100000' => '85611821105a30ab4df43e2344d6d383',
        'province.asp?provCode=043400000' => '01dd41c435c74fafb59e284acc16df0c',
        'province.asp?provCode=045600000' => '07ab6092a9c04bff892f1d39a42f956e',
        'province.asp?provCode=045800000' => '9284c75f6ac39a7d30c8b73e691dec43',
        'province.asp?provCode=050500000' => '328da3942800a5572ec2033d369c7513',
        'province.asp?provCode=051600000' => 'af61c10d70c2df80cfc5ebb521f6943f',
        'province.asp?provCode=051700000' => '6aadc1cf45df12bbbacad90aed1e5ea4',
        'province.asp?provCode=052000000' => '7ea74e775da9976c3d9e03669cab56b8',
        'province.asp?provCode=054100000' => '1e23af99c89ef54a1cc88e69f2d0704c',
        'province.asp?provCode=056200000' => '41862b29a3dbc812e10b2556fa647289',
        'province.asp?provCode=060400000' => '99f81a1def0f7862f22c096912631f12',
        'province.asp?provCode=060600000' => '9cc8e7a26e5d75920b81015ea9e8b242',
        'province.asp?provCode=061900000' => 'c1ad5a38dbe372ac936434e435b4574e',
        'province.asp?provCode=063000000' => 'f20dbb3ef5b02ec7e718308bb117fd39',
        'province.asp?provCode=064500000' => 'b9d630a9738984582f2aaadea026852a',
        'province.asp?provCode=067900000' => '65cdb4f63776221f8b2b9316008020d4',
        'province.asp?provCode=071200000' => '5019391053a0e81eae24adfd7c366678',
        'province.asp?provCode=072200000' => '38969d884aaa47db23e8781a6c81a803',
        'province.asp?provCode=074600000' => '90c3f4bb4fb2b47ce8c766596d498b40',
        'province.asp?provCode=076100000' => '84cab9aecab003648707ca815d4452b2',
        'province.asp?provCode=082600000' => 'ccd5911bf65a5e0b7a4e2e3e620cb8d2',
        'province.asp?provCode=083700000' => '4bc3429268a9eeb3c93ee46ea001e374',
        'province.asp?provCode=084800000' => 'b262559a1ef433558b07fd50ffcaf608',
        'province.asp?provCode=086000000' => '978fb4fe298d675c1bda7356a5b7bdf6',
        'province.asp?provCode=086400000' => '148f9977f1192219bb56a061dc929a3c',
        'province.asp?provCode=087800000' => 'cfefc8a7589102ebc420f1945e39adeb',
        'province.asp?provCode=097200000' => 'aeb111a6825d54af73e8145ae984c41f',
        'province.asp?provCode=097300000' => 'f1f0f85ad0db6cade785814e0ceaea92',
        'province.asp?provCode=098300000' => '4963257ddb6c97dec2b01aa342c93981',
        'province.asp?provCode=099700000' => 'e1097462f00cb11bb5d36041978c430a',
        'province.asp?provCode=101300000' => '63fd8e7846526a207e1984a36ca60fab',
        'province.asp?provCode=101800000' => 'cf4541a96fe7cb8de54e0a227a7783a0',
        'province.asp?provCode=103500000' => 'af5f3accaa1cc7fc280ca13efdb74352',
        'province.asp?provCode=104200000' => '70a64a2ded5848d1350004dadea063cf',
        'province.asp?provCode=104300000' => '3c41959acea55f6db617077f1b4a15be',
        'province.asp?provCode=112300000' => '565646ab0d272b38ecfe955d04dfd398',
        'province.asp?provCode=112400000' => 'bd3cdb7a15425cea4a69b7ed834cfba1',
        'province.asp?provCode=112500000' => '17cafcddaa7c45f7a31276bb344e56ff',
        'province.asp?provCode=118200000' => '6036c359f85b089e1f1e18ca062baf1b',
        'province.asp?provCode=124700000' => '703ae6fc850ab11cb58f129510fb9b3a',
        'province.asp?provCode=126300000' => '152d828bcd62553f6cc7e1a212336097',
        'province.asp?provCode=126500000' => 'f6fbc0221be427eacd8a38757a478e9d',
        'province.asp?provCode=128000000' => 'fe1b9ee85a8eddbaeb13b1f6f7f92342',
        'province.asp?provCode=129800000' => 'f4025c2f0b679db31371c44004332e3a',
        'province.asp?provCode=133900000' => '7344914e509a31fa89d7c7b8ac71145c',
        'province.asp?provCode=137400000' => '7981c2b255f229d72fa5879385667ecf',
        'province.asp?provCode=137500000' => '0b3873cb773a590ada38ec9f6cd9e7f8',
        'province.asp?provCode=137600000' => 'e9f8d0bf4759e505efaf1b221fcad10a',
        'province.asp?provCode=140100000' => 'fef88cac49cfbc0230225b9cca87f85a',
        'province.asp?provCode=141100000' => '60649c96cfeb0e01429f053c274180ab',
        'province.asp?provCode=142700000' => 'bd5ba6b0732c2fe71517145061ee2cb2',
        'province.asp?provCode=143200000' => '5803429f5dc03e5119a240c7246cef1b',
        'province.asp?provCode=144400000' => '449865a09a3562c96065f5bdf5f5ffc8',
        'province.asp?provCode=148100000' => '71d17fbb4b9864da763731e29eab56a7',
        'province.asp?provCode=150700000' => '8e4a8db61d8a4801c55a88371251d975',
        'province.asp?provCode=153600000' => '0aa4ef0ed175829020a62e46a3e87038',
        'province.asp?provCode=153800000' => 'dc89f9e9c4a398a785183a50654f1fe6',
        'province.asp?provCode=156600000' => 'eea2527f8e50f01c0055a7b27a0134e7',
        'province.asp?provCode=157000000' => 'c21fa7c1fdf0ce1f9da6e5f362f05f7e',
        'province.asp?provCode=160200000' => 'e751daa14d1d4eeedf274b46b8b97990',
        'province.asp?provCode=160300000' => '10cb1ebe0e8dba48d55713d5ee45b85e',
        'province.asp?provCode=166700000' => '9b1649d9baff364ebcb28ed693470055',
        'province.asp?provCode=166800000' => 'e3c4d1c12add4a6adb07791ca37b5c8e',
        'province.asp?provCode=168500000' => '32dc8ab480c582d038b94d1b5d57e294',
        'province.asp?provCode=174000000' => '6a8c9a424fc76bda3585815922d3b215',
        'province.asp?provCode=175100000' => '39f5b71cf63042fbabfbfa7f61ffb600',
        'province.asp?provCode=175200000' => 'c6a7d85fc102e2a7381f86582d666def',
        'province.asp?provCode=175300000' => 'e15d04a25af7c3d0219e21bb4bcf9323',
        'province.asp?provCode=175900000' => 'ce39d0aeab0abdfd347b7b8de9b58197',
        'regview.asp?region=01' => 'f76424330c41161f5939ad5108d4181a',
        'regview.asp?region=02' => '5d63f936e2b287064912c21a3a2316a3',
        'regview.asp?region=03' => '1e062303c9c5b27ef8634fcf883a81b3',
        'regview.asp?region=04' => '7b337d3b8a81196c15de7b33439173bf',
        'regview.asp?region=05' => '3b810c982658b6890f6d8b13bfd5f0ea',
        'regview.asp?region=06' => 'b19da6f4c5b6a02d6a8a87688249d44b',
        'regview.asp?region=07' => '6901e417ac2b26d19f8438760dc3d3fa',
        'regview.asp?region=08' => '01e861d026d25aef832ee4544a5963ff',
        'regview.asp?region=09' => 'e321b05f14465c7c20bd000b127f12ee',
        'regview.asp?region=10' => 'e3084868a40f5986b7cfd1381f1142c3',
        'regview.asp?region=11' => '55da42c45b97f2dd07c3ce8fece9b510',
        'regview.asp?region=12' => 'f9ecb9d4bb0a51ee69033385917596af',
        'regview.asp?region=13' => '49ab17e86f5fc485462a690104412ad4',
        'regview.asp?region=14' => '9929b3c6b68fe253163fb4b8140feb7a',
        'regview.asp?region=15' => '4188d8be288450bb858d26bbe350f6aa',
        'regview.asp?region=16' => '69ad031a4431f8612d6126988f5f808d',
        'regview.asp?region=17' => '9f8215f23d3731b1c7eb632e6fa9ac07'
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
