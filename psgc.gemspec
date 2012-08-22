# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "psgc"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alistair A. Israel"]
  s.date = "2012-08-22"
  s.description = "A Ruby gem that provides PSGC (Philippine Standard Geographic Code) data."
  s.email = "aisrel@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".gitignore",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "data/01/0128/cities.csv",
    "data/01/0128/municipalities.csv",
    "data/01/0129/cities.csv",
    "data/01/0129/municipalities.csv",
    "data/01/0133/cities.csv",
    "data/01/0133/municipalities.csv",
    "data/01/0155/cities.csv",
    "data/01/0155/municipalities.csv",
    "data/01/provinces.csv",
    "data/02/0209/municipalities.csv",
    "data/02/0215/cities.csv",
    "data/02/0215/municipalities.csv",
    "data/02/0231/cities.csv",
    "data/02/0231/municipalities.csv",
    "data/02/0250/municipalities.csv",
    "data/02/0257/municipalities.csv",
    "data/02/provinces.csv",
    "data/03/0308/cities.csv",
    "data/03/0308/municipalities.csv",
    "data/03/0314/cities.csv",
    "data/03/0314/municipalities.csv",
    "data/03/0349/cities.csv",
    "data/03/0349/municipalities.csv",
    "data/03/0354/cities.csv",
    "data/03/0354/municipalities.csv",
    "data/03/0369/cities.csv",
    "data/03/0369/municipalities.csv",
    "data/03/0371/cities.csv",
    "data/03/0371/municipalities.csv",
    "data/03/0377/municipalities.csv",
    "data/03/provinces.csv",
    "data/04/0410/cities.csv",
    "data/04/0410/municipalities.csv",
    "data/04/0421/cities.csv",
    "data/04/0421/municipalities.csv",
    "data/04/0434/cities.csv",
    "data/04/0434/municipalities.csv",
    "data/04/0456/cities.csv",
    "data/04/0456/municipalities.csv",
    "data/04/0458/cities.csv",
    "data/04/0458/municipalities.csv",
    "data/04/provinces.csv",
    "data/05/0505/cities.csv",
    "data/05/0505/municipalities.csv",
    "data/05/0516/municipalities.csv",
    "data/05/0517/cities.csv",
    "data/05/0517/municipalities.csv",
    "data/05/0520/municipalities.csv",
    "data/05/0541/cities.csv",
    "data/05/0541/municipalities.csv",
    "data/05/0562/cities.csv",
    "data/05/0562/municipalities.csv",
    "data/05/provinces.csv",
    "data/06/0604/municipalities.csv",
    "data/06/0606/municipalities.csv",
    "data/06/0619/cities.csv",
    "data/06/0619/municipalities.csv",
    "data/06/0630/cities.csv",
    "data/06/0630/municipalities.csv",
    "data/06/0645/cities.csv",
    "data/06/0645/municipalities.csv",
    "data/06/0679/municipalities.csv",
    "data/06/provinces.csv",
    "data/07/0712/cities.csv",
    "data/07/0712/municipalities.csv",
    "data/07/0722/cities.csv",
    "data/07/0722/municipalities.csv",
    "data/07/0746/cities.csv",
    "data/07/0746/municipalities.csv",
    "data/07/0761/municipalities.csv",
    "data/07/provinces.csv",
    "data/08/0826/cities.csv",
    "data/08/0826/municipalities.csv",
    "data/08/0837/cities.csv",
    "data/08/0837/municipalities.csv",
    "data/08/0848/municipalities.csv",
    "data/08/0860/cities.csv",
    "data/08/0860/municipalities.csv",
    "data/08/0864/cities.csv",
    "data/08/0864/municipalities.csv",
    "data/08/0878/municipalities.csv",
    "data/08/provinces.csv",
    "data/09/0972/cities.csv",
    "data/09/0972/municipalities.csv",
    "data/09/0973/cities.csv",
    "data/09/0973/municipalities.csv",
    "data/09/0983/municipalities.csv",
    "data/09/0997/cities.csv",
    "data/09/provinces.csv",
    "data/10/1013/cities.csv",
    "data/10/1013/municipalities.csv",
    "data/10/1018/municipalities.csv",
    "data/10/1035/cities.csv",
    "data/10/1035/municipalities.csv",
    "data/10/1042/cities.csv",
    "data/10/1042/municipalities.csv",
    "data/10/1043/cities.csv",
    "data/10/1043/municipalities.csv",
    "data/10/provinces.csv",
    "data/11/1123/cities.csv",
    "data/11/1123/municipalities.csv",
    "data/11/1124/cities.csv",
    "data/11/1124/municipalities.csv",
    "data/11/1125/cities.csv",
    "data/11/1125/municipalities.csv",
    "data/11/1182/municipalities.csv",
    "data/11/provinces.csv",
    "data/12/1247/cities.csv",
    "data/12/1247/municipalities.csv",
    "data/12/1263/cities.csv",
    "data/12/1263/municipalities.csv",
    "data/12/1265/cities.csv",
    "data/12/1265/municipalities.csv",
    "data/12/1280/municipalities.csv",
    "data/12/1298/cities.csv",
    "data/12/provinces.csv",
    "data/13/1339/cities.csv",
    "data/13/1374/cities.csv",
    "data/13/1375/cities.csv",
    "data/13/1376/cities.csv",
    "data/13/1376/municipalities.csv",
    "data/13/provinces.csv",
    "data/14/1401/municipalities.csv",
    "data/14/1411/cities.csv",
    "data/14/1411/municipalities.csv",
    "data/14/1427/municipalities.csv",
    "data/14/1432/cities.csv",
    "data/14/1432/municipalities.csv",
    "data/14/1444/municipalities.csv",
    "data/14/1481/municipalities.csv",
    "data/14/provinces.csv",
    "data/15/1507/cities.csv",
    "data/15/1507/municipalities.csv",
    "data/15/1536/cities.csv",
    "data/15/1536/municipalities.csv",
    "data/15/1538/cities.csv",
    "data/15/1538/municipalities.csv",
    "data/15/1566/municipalities.csv",
    "data/15/1570/municipalities.csv",
    "data/15/provinces.csv",
    "data/16/1602/cities.csv",
    "data/16/1602/municipalities.csv",
    "data/16/1603/cities.csv",
    "data/16/1603/municipalities.csv",
    "data/16/1667/cities.csv",
    "data/16/1667/municipalities.csv",
    "data/16/1668/cities.csv",
    "data/16/1668/municipalities.csv",
    "data/16/1685/municipalities.csv",
    "data/16/provinces.csv",
    "data/17/1740/municipalities.csv",
    "data/17/1751/municipalities.csv",
    "data/17/1752/cities.csv",
    "data/17/1752/municipalities.csv",
    "data/17/1753/cities.csv",
    "data/17/1753/municipalities.csv",
    "data/17/1759/municipalities.csv",
    "data/17/provinces.csv",
    "data/regions.csv",
    "lib/psgc.rb",
    "lib/psgc/city_or_municipality.rb",
    "lib/psgc/import.rb",
    "lib/psgc/import/import_province_municipalities.rb",
    "lib/psgc/import/import_region_provinces.rb",
    "lib/psgc/import/import_regions.rb",
    "lib/psgc/province.rb",
    "lib/psgc/rake_task.rb",
    "lib/psgc/region.rb",
    "psgc.gemspec",
    "spec/psgc/import/download_manager_spec.rb",
    "spec/psgc/import/import_regions_spec.rb",
    "spec/psgc/import/import_spec.rb",
    "spec/psgc/province_spec.rb",
    "spec/psgc/psgc_spec.rb",
    "spec/psgc/region_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/AlistairIsrael/psgc"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Philippine Standard Geographic Code"
  s.test_files = ["spec/psgc/import/download_manager_spec.rb", "spec/psgc/import/import_regions_spec.rb", "spec/psgc/import/import_spec.rb", "spec/psgc/province_spec.rb", "spec/psgc/psgc_spec.rb", "spec/psgc/region_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.11"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, ["~> 1.5"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.11"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<nokogiri>, ["~> 1.5"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.11"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<nokogiri>, ["~> 1.5"])
  end
end

