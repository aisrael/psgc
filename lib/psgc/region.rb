require 'yaml'

module PSGC
  class Region < Struct.new :id, :name
    def initialize(*args)
      super(*args)
    end
    
    REGION_DATA = File.join(PSGC::DATA_DIR, 'regions.yml')
    
    class << self
      def all
        @@all ||= load_regions
      end
      
      private
      
      def load_regions
        regions = []
        File.open(REGION_DATA) do |io|
          YAML::load_documents(io) do |h|
            regions << PSGC::Region.new(h['id'], h['name'])
          end
        end
        regions
      end
    end

    def code
      "#{id}0000000"
    end
    
    def provinces
      @provinces ||= load_provinces
    end
    
    private
    
    NOT_A_PROVINCE = ' (Not a Province)'
    
    def province_data_path
      File.join(PSGC::DATA_DIR, id, 'provinces.yml')
    end
    
    def load_provinces
      provinces = []
      File.open(province_data_path) do |io|
        YAML::load_documents(io) do |h|
          provinces << to_province_or_district(h)          
        end
      end
      provinces
    end

    # TODO Move to ProvinceOrDistrict    
    def to_province_or_district(h)
      name = h['name']
      if name.end_with? NOT_A_PROVINCE
        PSGC::District.new h['id'], name.chomp(NOT_A_PROVINCE)
      else            
        PSGC::Province.new h['id'], name
      end
    end

  end
end
