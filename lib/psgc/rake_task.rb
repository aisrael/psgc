require 'fileutils'

require 'rake'
require 'rake/tasklib'

module PSGC
  class RakeTask < ::Rake::TaskLib
    WEB_DIR = File.expand_path(File.join(__FILE__, '..', '..', '..', 'web', 'www.ncsb.gov.ph'))
    
    def initialize(*args)
      yield self if block_given?
      
      namespace :psgc do
        
        directory WEB_DIR
        
        desc "Fetch PSGC Web pages from www.ncsb.gov.ph"
        task :fetch => WEB_DIR do
          self.fetch
        end
        
        desc "Parse PSGC data from cached HTML files"
        task :parse do
          self.parse
        end
      end
    end
    
    # Fetch 
    def fetch
      puts "WEB_DIR: #{WEB_DIR}"
    end
    
    def parse
      puts "Parse!"
    end
  end
end
