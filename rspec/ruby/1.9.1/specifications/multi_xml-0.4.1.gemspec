# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{multi_xml}
  s.version = "0.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Erik Michaels-Ober}]
  s.date = %q{2011-09-26}
  s.description = %q{A gem to provide swappable XML backends utilizing LibXML, Nokogiri, Ox, or REXML.}
  s.email = %q{sferik@gmail.com}
  s.homepage = %q{https://github.com/sferik/multi_xml}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{A generic swappable back-end for XML parsing}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<libxml-ruby>, ["~> 2.0"])
      s.add_development_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_development_dependency(%q<ox>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<rdiscount>, ["~> 1.6"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
    else
      s.add_dependency(%q<libxml-ruby>, ["~> 2.0"])
      s.add_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_dependency(%q<ox>, ["~> 1.3"])
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<rdiscount>, ["~> 1.6"])
      s.add_dependency(%q<rspec>, ["~> 2.6"])
      s.add_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
    end
  else
    s.add_dependency(%q<libxml-ruby>, ["~> 2.0"])
    s.add_dependency(%q<nokogiri>, ["~> 1.4"])
    s.add_dependency(%q<ox>, ["~> 1.3"])
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<rdiscount>, ["~> 1.6"])
    s.add_dependency(%q<rspec>, ["~> 2.6"])
    s.add_dependency(%q<simplecov>, ["~> 0.4"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
  end
end
