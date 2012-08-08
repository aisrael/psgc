require 'yaml'

module PSGC
  class Region < Struct.new :id, :name
    attr_accessor :provinces
    
    def initialize(*args)
      super(*args)
      @provinces = [Province.new]
    end
    
    REGION_DATA = File.join(PSGC::DATA_DIR, 'regions.yml')

    class << self
      def all
        @@all ||= load_regions
      end
      
      def load_regions
        puts 'bah'
        [Region.new(1, 'Region I')]
      end
    end
  end
end
