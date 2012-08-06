require 'fileutils'

require 'rake'
require 'rake/tasklib'

module PSGC
  class RakeTask < ::Rake::TaskLib
    NCSB_BASE_URI = URI('http://www.nscb.gov.ph/activestats/psgc/')
    
    WEB_DIR = File.expand_path(File.join(__FILE__, '..', '..', '..', 'web', NCSB_BASE_URI.host))
    
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
   
    LISTREG_ASP = 'listreg.asp'
     
    # Fetch
    def fetch      
      src = NCSB_BASE_URI + LISTREG_ASP      
      listreg = File.join(WEB_DIR, File.basename(src.path)) 
      
      cmd = "curl #{src} > #{out}"
      puts cmd
      system(cmd)
    end
    
    def parse
      puts "Parse!"
    end
  end
end
