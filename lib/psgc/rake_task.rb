require 'fileutils'

require 'rake'
require 'rake/tasklib'

module PSGC
  class RakeTask < ::Rake::TaskLib
    
    def base_dir
      PSGC::Import::Base.dir
    end
    
    def base_dir=(dir)
      PSGC::Import::Base.dir = dir
    end
    
    def base_uri
      PSGC::Import::Base.uri
    end
    
    def base_uri=(uri)
      PSGC::Import::Base.uri = uri
    end

    def initialize(*args)
      yield self if block_given?
      
      namespace :psgc do
        
        directory base_dir
        
        desc "Fetch PSGC Web pages from www.ncsb.gov.ph"
        task :fetch => base_dir do
          reg = PSGC::Import::ListReg.new
          reg.fetch
        end
      end
    end
  end
end
