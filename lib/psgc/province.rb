module PSGC
  class ProvinceOrDistrict < Struct.new :id, :name
    def code
      "#{id}00000"
    end
    def is_province?
      is_a? Province
    end
    
    def cities
      @@cities ||= load_cities
    end
    
    def municipalities
      @@municipalities ||= load_municipalities
    end
    
    private
    
    def base_dir
      File.join(PSGC::DATA_DIR, id[0, 2], id)
    end
    
    def cities_data
      File.join(base_dir, 'cities.csv')
    end
    
    def municipalities_data
      File.join(base_dir, 'municipalities.csv')
    end
    
    def load_cities
      CSV.open(cities_data) do |csv|
        csv.shift # skip header row
        csv.read.map {|id, name| PSGC::City.new(id, name) }
      end
    end
  end
 
  class Province < ProvinceOrDistrict
  end

  class District < ProvinceOrDistrict
  end
end
