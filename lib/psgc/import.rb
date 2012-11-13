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
        'listreg.asp' => 'f6543ea49dabe4e5479305acdebc62f8', 
        'province.asp?provCode=012800000' => '9226f9252ccb362d7825619d1dcd2936', 
        'province.asp?provCode=012900000' => '33dca769cbe07776f3cb7444b1cd2400', 
        'province.asp?provCode=013300000' => 'ff88d17094b3152e23e89e52e8ddf195', 
        'province.asp?provCode=015500000' => 'b32d2de1b25495f16e431942241a9065', 
        'province.asp?provCode=020900000' => '7c952e666bc7a3b8126e5f4ffd3a9cdb', 
        'province.asp?provCode=021500000' => '0c653eb87392685a40de81e8ceb391fc', 
        'province.asp?provCode=023100000' => 'a6b3dd4207b6a1208129f5d1821a4376', 
        'province.asp?provCode=025000000' => 'ef269064af7468557affec0e800d98d5', 
        'province.asp?provCode=025700000' => 'ba5fd66593d564d44f5c3c0296418cda', 
        'province.asp?provCode=030800000' => '0eb0ee8fabb1401b5c876b1d88a07e2c', 
        'province.asp?provCode=031400000' => 'ec9b9e6c4611d676dbe8cd29c6e8e09f', 
        'province.asp?provCode=034900000' => '0fbaf20a26c7e9e8a565184b2345ebeb', 
        'province.asp?provCode=035400000' => 'd495348339dd6a757e748371b3509098', 
        'province.asp?provCode=036900000' => '146414ffb41968b1f7bedde55f8482bd', 
        'province.asp?provCode=037100000' => '9a63b33a45b878d0f4f2e8030dc8a911', 
        'province.asp?provCode=037700000' => '486553efb4e12d80bcff98156b81971d', 
        'province.asp?provCode=041000000' => 'e0ab643e98e17ac7b6e9aa21192d40a7', 
        'province.asp?provCode=042100000' => '11fa72a4fefbd8442e7980ffcbe6867a', 
        'province.asp?provCode=043400000' => 'aaa5eb5944e726b6f9b182500d26df50', 
        'province.asp?provCode=045600000' => 'b2b822a944e30b4b8ca9318957c8f11c', 
        'province.asp?provCode=045800000' => '30ad51037909139ad6aad8046faa0332', 
        'province.asp?provCode=050500000' => '52555238db301d7264009dd3fb0ba136', 
        'province.asp?provCode=051600000' => 'eb1ae20a30556fae6e366f7a23766e27', 
        'province.asp?provCode=051700000' => '1f3159e1c8ef1c4ab77e62cbe12af9b5', 
        'province.asp?provCode=052000000' => 'd66871ee3cd59904e24d9e2e58f4d0cf', 
        'province.asp?provCode=054100000' => 'dcc944a47c54153181264dcdbe318c1f', 
        'province.asp?provCode=056200000' => '8f4ed5e996dc5042770f4bfbcf2c4d3b', 
        'province.asp?provCode=060400000' => 'eb42b6f9dfc5f91f925e5e3b519a44cc', 
        'province.asp?provCode=060600000' => '9bd8647787281344cc74373f41ab1a0e', 
        'province.asp?provCode=061900000' => '37233626d8d89c4da4c81303febf8535', 
        'province.asp?provCode=063000000' => '4819024d98b7848fb337f69d4fcdbdfc', 
        'province.asp?provCode=064500000' => 'b187c77098c655aafaef80dd7995fda9', 
        'province.asp?provCode=067900000' => '5468f1976ca1605adc6ef4a9dbcc99ac', 
        'province.asp?provCode=071200000' => 'c3d40b225f9e321d3dca26a63deacbc3', 
        'province.asp?provCode=072200000' => 'a930b5e47dc37c51f132b5885a7febaf', 
        'province.asp?provCode=074600000' => '8f765215a82f5b65af63549d46d1a189', 
        'province.asp?provCode=076100000' => '3916138c668e37f8c635ba07a5e7e1e1', 
        'province.asp?provCode=082600000' => '330b449213233147c9b968b33e32ddc9', 
        'province.asp?provCode=083700000' => '4979612aa9a26a3f4833204f63678d05', 
        'province.asp?provCode=084800000' => '1085a8296834237de1819870e5788aad', 
        'province.asp?provCode=086000000' => '1c781f7c43714960169fbf5e7d577a06', 
        'province.asp?provCode=086400000' => '77a750e9d994b9a4e01ffe8bde43ad19', 
        'province.asp?provCode=087800000' => 'bac7d65ead916049bd206a98a91caa0a', 
        'province.asp?provCode=097200000' => 'b911dea244ae3107bedfc95165193a84', 
        'province.asp?provCode=097300000' => '0e83b8c1d44f26b9ee848bd10a562d07', 
        'province.asp?provCode=098300000' => 'd2899ff5a1902e00bc04ac1916ad3a3c', 
        'province.asp?provCode=099700000' => '0e5fa16764e858b4d510de084acafe5a', 
        'province.asp?provCode=101300000' => '0a69f3d6c287a61353a33f489d4fab24', 
        'province.asp?provCode=101800000' => '1927de382b13ad7f24a046245dd7478e', 
        'province.asp?provCode=103500000' => '66dce89ce95a0f92092f27677a7749e1', 
        'province.asp?provCode=104200000' => '4a38d6282d45dfe2e74454917062dcc6', 
        'province.asp?provCode=104300000' => '40be2ab6fb0791b72385e4583396e646', 
        'province.asp?provCode=112300000' => 'c8e52097901ec7e951b2a5e406737580', 
        'province.asp?provCode=112400000' => '8dd133f45924be81954f640b0ca522a1', 
        'province.asp?provCode=112500000' => '43a52a54e10eb0537a14e4467151a6cf', 
        'province.asp?provCode=118200000' => 'de844ffea3497dd38c2b98cc24411dcf', 
        'province.asp?provCode=124700000' => '7d44d3310cbc2cb29160b5ef4ba11ff1', 
        'province.asp?provCode=126300000' => '31146d14d0c14453e2ead31ca9cdd848', 
        'province.asp?provCode=126500000' => '849985078772b99b7ab9b658a38a5eb1', 
        'province.asp?provCode=128000000' => 'eb0ae765ce3d6f389a53f38113c68778', 
        'province.asp?provCode=129800000' => 'be79bfe02b101e81a6a91e1f48cec8d3', 
        'province.asp?provCode=133900000' => 'b3ec2c817613f0c6f6762e9ffbc83add', 
        'province.asp?provCode=137400000' => '9beb5fde63b34c08659f99f7131e4fab', 
        'province.asp?provCode=137500000' => '3e59e4fdbdbaa11603a9b89ec6ed4100', 
        'province.asp?provCode=137600000' => '20589be56169ea9ffe20f7baf9cb899a', 
        'province.asp?provCode=140100000' => 'fd9f5320e08fc650f0a024cd0112e87d', 
        'province.asp?provCode=141100000' => '1b3230a9c4b8c55d51caef7c7eded925', 
        'province.asp?provCode=142700000' => '965667d6a177dd8fcfd85848c8bd98df', 
        'province.asp?provCode=143200000' => '008d38b8710bf0da1a91d4ebcace9b47', 
        'province.asp?provCode=144400000' => 'a6e6ff9d803fca9d5e4edcfee986acda', 
        'province.asp?provCode=148100000' => '830112be70d1b7faa54a31326d7bd4ac', 
        'province.asp?provCode=150700000' => '13ea2745cb477047242faf47970c4834', 
        'province.asp?provCode=153600000' => 'e701277414e97d7989f1db48c1c6c9ac', 
        'province.asp?provCode=153800000' => '6a49e3af3e8a01954d3a98a7d7b19fcb', 
        'province.asp?provCode=156600000' => 'f207874d37f8967b7823d44285ac2b9c', 
        'province.asp?provCode=157000000' => 'c2b2dcf0c39ab96338301304acd83e9d', 
        'province.asp?provCode=160200000' => '3a93b03c3c776d96ba6c37ead09abd2f', 
        'province.asp?provCode=160300000' => 'c6326d11e5f3b20fd201d710527e7f4e', 
        'province.asp?provCode=166700000' => '21e109fe110011154cd1d41fb52d02f4', 
        'province.asp?provCode=166800000' => '8e7e037046ffbea7db1b3cc12d0d152d', 
        'province.asp?provCode=168500000' => 'ba5cf560db08ddb78806a7882d93df70', 
        'province.asp?provCode=174000000' => '4dfa85420e78268bda265826f9151d8e', 
        'province.asp?provCode=175100000' => '691956ff92695f5bdbfaa0d6801c7d93', 
        'province.asp?provCode=175200000' => 'adeec6343154707362264e0cf3ce0309', 
        'province.asp?provCode=175300000' => 'cf335722b8fdde9f70cc16b1c30bceda', 
        'province.asp?provCode=175900000' => '4994b9bf2ecb6fb9f30ddfbd3af369fc', 
        'regview.asp?region=01' => '102c8621962829d5c8936568045da794', 
        'regview.asp?region=02' => 'c514826d887efd3b0a9bd43a56f6822b', 
        'regview.asp?region=03' => '14b180ab8f313a00e7512d56cdc9d0f3', 
        'regview.asp?region=04' => 'cdbad687095d1ab215a440e1421cf253', 
        'regview.asp?region=05' => '951b7f2f6a6e47c1bc5d9134b45b25a4', 
        'regview.asp?region=06' => '0573a545c9f541006b1ac2b984fb74fe', 
        'regview.asp?region=07' => '87a8ca73e61304d0388257bb6a30e2d1', 
        'regview.asp?region=08' => '876cde39ba2527c9307be726f37d2374', 
        'regview.asp?region=09' => '503208a856fad2a6f3b25fc813b8bcf5', 
        'regview.asp?region=10' => '55fcb4e63f3f5115f3295b3452fa1088', 
        'regview.asp?region=11' => '73aecdeee4300a7828618bf5ea7e6339', 
        'regview.asp?region=12' => '7cadc84967dbff9a02059b2bae5b551e', 
        'regview.asp?region=13' => 'a14241a49780b30e1d80789eb0d7c67b', 
        'regview.asp?region=14' => '42a5ae8396d0de744b11b84db40a53b4', 
        'regview.asp?region=15' => 'd366240d5467d3a94021f4186a35973d', 
        'regview.asp?region=16' => 'a046df3f5e2eae41e77106a718b67073', 
        'regview.asp?region=17' => '5131d5cb1de4fdb97fc20fc28dd59458'
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
