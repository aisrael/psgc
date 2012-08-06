require 'rake'
require 'rake/tasklib'

module PSGC
  class RakeTask < ::Rake::TaskLib
    def initialize(*args)
      yield self if block_given?        
    end
    
    def fetch
      puts "Fetch!"
    end
    
    def parse
      puts "Parse!"
    end
  end
end