require 'csv'

module PSGC
  class Region < Struct.new :id, :name
    def initialize(*args)
      super(*args)
    end

    REGION_DATA = File.join(PSGC::DATA_DIR, 'regions.csv')

    class << self
      def all
        @@all ||= load_regions
      end

      def [](id)
        case
        when id.kind_of?(Fixnum)
          map_by_num[id]
        when id.kind_of?(String)
          map_by_num[id]
        else
          raise "\"#{id}\" expected either String or Fixnum (was #{id.class})"
        end
      end

      private

      def load_regions
        regions = CSV.open(REGION_DATA) do |csv|
          csv.shift # skip header row
          csv.read.map {|row| PSGC::Region.new(row[0], row[1])}
        end
      end

      def map_by_num
        @@map_by_num ||= all.inject({}) {|hash, region| hash[region.id.to_i] = region; hash }
      end

      def map_by_string
        @@map_by_string ||= all.inject({}) {|hash, region| hash[region.id] = region; hash }
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
      File.join(PSGC::DATA_DIR, id, 'provinces.csv')
    end

    def load_provinces
      CSV.open(province_data_path) do |csv|
        csv.shift # skip header row
        csv.read.map {|row| to_province_or_district(*row)}
      end
    end

    # TODO Move to ProvinceOrDistrict
    def to_province_or_district(id, name)
      if name.end_with? NOT_A_PROVINCE
        PSGC::District.new id, name.chomp(NOT_A_PROVINCE)
      else
        PSGC::Province.new id, name
      end
    end

  end
end
