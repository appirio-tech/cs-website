# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{savon}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Daniel Harrington}]
  s.date = %q{2012-06-09}
  s.description = %q{Ruby's heavy metal SOAP client}
  s.email = %q{me@rubiii.com}
  s.homepage = %q{http://savonrb.com}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{savon}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Heavy metal Ruby SOAP client}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<nori>, ["~> 1.1"])
      s.add_runtime_dependency(%q<httpi>, ["~> 1.0"])
      s.add_runtime_dependency(%q<wasabi>, ["~> 2.2"])
      s.add_runtime_dependency(%q<akami>, ["~> 1.1"])
      s.add_runtime_dependency(%q<gyoku>, [">= 0.4.0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<rspec>, ["~> 2.10"])
      s.add_development_dependency(%q<mocha>, ["~> 0.11"])
      s.add_development_dependency(%q<timecop>, ["~> 0.3"])
    else
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<nori>, ["~> 1.1"])
      s.add_dependency(%q<httpi>, ["~> 1.0"])
      s.add_dependency(%q<wasabi>, ["~> 2.2"])
      s.add_dependency(%q<akami>, ["~> 1.1"])
      s.add_dependency(%q<gyoku>, [">= 0.4.0"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<rspec>, ["~> 2.10"])
      s.add_dependency(%q<mocha>, ["~> 0.11"])
      s.add_dependency(%q<timecop>, ["~> 0.3"])
    end
  else
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<nori>, ["~> 1.1"])
    s.add_dependency(%q<httpi>, ["~> 1.0"])
    s.add_dependency(%q<wasabi>, ["~> 2.2"])
    s.add_dependency(%q<akami>, ["~> 1.1"])
    s.add_dependency(%q<gyoku>, [">= 0.4.0"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<rspec>, ["~> 2.10"])
    s.add_dependency(%q<mocha>, ["~> 0.11"])
    s.add_dependency(%q<timecop>, ["~> 0.3"])
  end
end
