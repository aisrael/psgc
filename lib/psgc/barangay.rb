module PSGC
  class Barangay < Struct.new :id, :name, :urban, :population
    def is_urban?
      urban
    end
    def is_rural?
      !urban
    end
  end
end
