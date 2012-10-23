# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tilt}
  s.version = "1.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Ryan Tomayko}]
  s.date = %q{2011-08-25}
  s.description = %q{Generic interface to multiple Ruby template engines}
  s.email = %q{r@tomayko.com}
  s.executables = [%q{tilt}]
  s.files = [%q{bin/tilt}]
  s.homepage = %q{http://github.com/rtomayko/tilt/}
  s.rdoc_options = [%q{--line-numbers}, %q{--inline-source}, %q{--title}, %q{Tilt}, %q{--main}, %q{Tilt}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Generic interface to multiple Ruby template engines}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<contest>, [">= 0"])
      s.add_development_dependency(%q<builder>, [">= 0"])
      s.add_development_dependency(%q<erubis>, [">= 0"])
      s.add_development_dependency(%q<haml>, [">= 2.2.11"])
      s.add_development_dependency(%q<sass>, [">= 0"])
      s.add_development_dependency(%q<rdiscount>, [">= 0"])
      s.add_development_dependency(%q<liquid>, [">= 0"])
      s.add_development_dependency(%q<less>, [">= 0"])
      s.add_development_dependency(%q<radius>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<markaby>, [">= 0"])
      s.add_development_dependency(%q<coffee-script>, [">= 0"])
      s.add_development_dependency(%q<bluecloth>, [">= 0"])
      s.add_development_dependency(%q<RedCloth>, [">= 0"])
      s.add_development_dependency(%q<maruku>, [">= 0"])
      s.add_development_dependency(%q<creole>, [">= 0"])
      s.add_development_dependency(%q<kramdown>, [">= 0"])
      s.add_development_dependency(%q<redcarpet>, [">= 0"])
      s.add_development_dependency(%q<creole>, [">= 0"])
      s.add_development_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_development_dependency(%q<wikicloth>, [">= 0"])
      s.add_development_dependency(%q<redcarpet>, [">= 0"])
      s.add_development_dependency(%q<kramdown>, [">= 0"])
    else
      s.add_dependency(%q<contest>, [">= 0"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<erubis>, [">= 0"])
      s.add_dependency(%q<haml>, [">= 2.2.11"])
      s.add_dependency(%q<sass>, [">= 0"])
      s.add_dependency(%q<rdiscount>, [">= 0"])
      s.add_dependency(%q<liquid>, [">= 0"])
      s.add_dependency(%q<less>, [">= 0"])
      s.add_dependency(%q<radius>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<markaby>, [">= 0"])
      s.add_dependency(%q<coffee-script>, [">= 0"])
      s.add_dependency(%q<bluecloth>, [">= 0"])
      s.add_dependency(%q<RedCloth>, [">= 0"])
      s.add_dependency(%q<maruku>, [">= 0"])
      s.add_dependency(%q<creole>, [">= 0"])
      s.add_dependency(%q<kramdown>, [">= 0"])
      s.add_dependency(%q<redcarpet>, [">= 0"])
      s.add_dependency(%q<creole>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_dependency(%q<wikicloth>, [">= 0"])
      s.add_dependency(%q<redcarpet>, [">= 0"])
      s.add_dependency(%q<kramdown>, [">= 0"])
    end
  else
    s.add_dependency(%q<contest>, [">= 0"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<erubis>, [">= 0"])
    s.add_dependency(%q<haml>, [">= 2.2.11"])
    s.add_dependency(%q<sass>, [">= 0"])
    s.add_dependency(%q<rdiscount>, [">= 0"])
    s.add_dependency(%q<liquid>, [">= 0"])
    s.add_dependency(%q<less>, [">= 0"])
    s.add_dependency(%q<radius>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<markaby>, [">= 0"])
    s.add_dependency(%q<coffee-script>, [">= 0"])
    s.add_dependency(%q<bluecloth>, [">= 0"])
    s.add_dependency(%q<RedCloth>, [">= 0"])
    s.add_dependency(%q<maruku>, [">= 0"])
    s.add_dependency(%q<creole>, [">= 0"])
    s.add_dependency(%q<kramdown>, [">= 0"])
    s.add_dependency(%q<redcarpet>, [">= 0"])
    s.add_dependency(%q<creole>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
    s.add_dependency(%q<wikicloth>, [">= 0"])
    s.add_dependency(%q<redcarpet>, [">= 0"])
    s.add_dependency(%q<kramdown>, [">= 0"])
  end
end
