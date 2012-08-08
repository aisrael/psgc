require 'nokogiri'

module PSGC
  module Import
    # Import Region List
    class ImportRegions < Base
      def initialize
        super 'listreg.asp', '55349b2c7e24a01cf5a37673ada5b0f1'
      end
      
      def parse
        File.open(target) do |io|
          html = Nokogiri::HTML(io)
          
        end
      end
    end
  end
end
