module PSGC
  class Region < Struct.new :id, :name
    @all = []
    
    attr_accessor :provinces
    
    def initialize
      @provinces = [Province.new]
    end
  end
end
