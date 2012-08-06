module PSGC
  module Import

    # Base class for all other importers
    class Base < Struct.new :src
      @uri = URI('http://www.nscb.gov.ph/activestats/psgc/')
      class << self
        attr_reader :uri
        def uri=(uri)
          @uri = uri.is_a?(URI) ? uri : URI(uri)
        end
      end
      
      # Return the Base.uri + src
      def full_source
        URI.join(Base.uri, src)
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
