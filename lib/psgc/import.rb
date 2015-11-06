require 'uri'
require 'json'
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
        DownloadManager.fetch(src, target)
        parse
      end

      # noop
      def parse
      end

      protected

      def target
        u = URI(src)
        file = File.basename(u.path)
        if u.query
          file = file + '?' + u.query.split('&').first
        end
        @target ||= file
      end

      def full_target
        File.join(Base.dir, target)
      end

    end

    # Responsible for fetching and caching pages
    class DownloadManager

      CHECKSUMS = JSON.load(File.new("#{Base.dir}.CHECKSUMS"))

      class << self

        MAX_TRIES = 3

        def fetch(src, target)
          full_source = URI.join(Base.uri, src)
          full_target = File.join(Base.dir, target)
          if already_there(target, full_target)
            puts "#{target} already exists and matches expected hash, skipping"
          else
            puts "#{target} exists but doesn't match expected hash" if File.exists?(full_target)
            tries = MAX_TRIES
            success = false

            loop do
              max_time = 60 * (1 + (MAX_TRIES-tries)**2)
              success = cmd("curl -m #{max_time} \"#{full_source}\" > #{full_target}")
              return if success
              tries -= 1
              break if tries == 0
            end

            puts "`curl \"#{src}\" > #{target}` failed after multiple tries, giving up"
            exit 1
          end
        end

        # Check if file exists and its MD5 hash equals expected_md5, if present
        def already_there(target, full_target)
          File.exists?(full_target) and (!CHECKSUMS.key?(target) or Digest::MD5.file(full_target).hexdigest == CHECKSUMS[target])
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
