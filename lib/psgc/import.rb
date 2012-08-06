module PSGC
  module Import

    # Base class for all other importers
    class Base < Struct.new :src
      @uri = URI('http://www.nscb.gov.ph/activestats/psgc/')
      class << self
        attr_accessor :uri
      end
    end
    
    # Import Region List
    class ListReg < Base
      def initialize
        super 'listreg.asp'
      end
    end    
  end
end
