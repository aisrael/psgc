module PSGC
  module Import
    # Base class for all other importers
    class Base < Struct.new :src
      @uri = URI('http://www.nscb.gov.ph/activestats/psgc/')
      @dir = File.expand_path(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'web')))
      
      class << self
        attr_reader :uri, :dir
        def uri=(uri)
          @uri = uri.is_a?(URI) ? uri : URI(uri)
        end
      end
      
      # Return the Base.uri + src
      def full_source
        URI.join(Base.uri, src)
      end
    end
    
  end
end
