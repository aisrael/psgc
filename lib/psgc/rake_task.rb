require 'fileutils'

require 'rake'
require 'rake/tasklib'

require 'psgc/import'

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
        task :import => base_dir do
          reg = PSGC::Import::ImportRegions.new
          reg.fetch
        end
      end
    end
  end
end
