module PSGC
  class ProvinceOrDistrict < Struct.new :id, :name
    def code
      "#{id}00000"
    end
    def is_province?
      is_a? Province
    end
  end
  class Province < ProvinceOrDistrict
  end
  class District < ProvinceOrDistrict
  end
end
