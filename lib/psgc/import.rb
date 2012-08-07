require 'digest/md5'

module PSGC
  module Import
    # Base class for all other importers
    class Base < Struct.new :src, :expected_md5
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
        target = File.join(Base.dir, src)
        cmd("curl #{full_source} > #{target}") unless already_there(target)
      end
      
      # noop
      def parse
      end
      
      protected

      # Check if file exists and its MD5 hash equals expected_md5      
      def already_there(file)
        File.exists?(file) and Digest::MD5.file(file).hexdigest == expected_md5       
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
