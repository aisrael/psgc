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
      
      # Return the Base.uri + src
      def full_source
        URI.join(Base.uri, src)
      end
      
      # Use `curl` to get the desired page
      def fetch
        cmd = "curl #{full_source} > #{File.join(Base.dir, src)}"
        puts cmd
        system(cmd)
      end
    end
    
  end
end
