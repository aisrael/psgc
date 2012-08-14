module PSGC
  DATA_DIR = File.expand_path(File.join('..', '..', 'data'), __FILE__)
end

require 'psgc/city_or_municipality'
require 'psgc/province'
require 'psgc/region'
