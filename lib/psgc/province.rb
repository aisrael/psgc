module PSGC
  class ProvinceOrDistrict < Struct.new :id, :name
    def code
      "#{id}00000"
    end
    def province?
      is_a? Province
    end
    
    def cities
      @@cities ||= load(cities_data, PSGC::City)
    end
    
    def municipalities
      @@municipalities ||= load(municipalities_data, PSGC::Municipality)
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
    
    def load(csv_file, cls)
      CSV.open(csv_file) do |csv|
        csv.shift # skip header row
        csv.read.map {|id, name| cls.new(id, name)}
      end
    end

  end
 
  class Province < ProvinceOrDistrict
  end

  class District < ProvinceOrDistrict
  end
end
