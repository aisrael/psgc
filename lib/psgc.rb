module PSGC
  DATA_DIR = File.expand_path(File.join('..', '..', 'data'), __FILE__)
end

require 'psgc/province'
require 'psgc/region'
