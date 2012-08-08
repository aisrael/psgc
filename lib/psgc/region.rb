module PSGC
  class Region < Struct.new :id, :name
    @all = []
    
    attr_accessor :provinces
    
    def initialize(id, name)
      super(id, name)
      @provinces = [Province.new]
    end
  end
end
