module PSGC
  class Province < Struct.new :id, :name
    PROVINCE_DATA = File.join(PSGC::DATA_DIR, 'provinces.yml')
  end
end
