# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wasabi}
  s.version = "2.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Daniel Harrington}]
  s.date = %q{2012-06-28}
  s.description = %q{A simple WSDL parser}
  s.email = [%q{me@rubiii.com}]
  s.homepage = %q{https://github.com/rubiii/wasabi}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{wasabi}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{A simple WSDL parser}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httpi>, ["~> 1.0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<rspec>, ["~> 2.10"])
      s.add_development_dependency(%q<mocha>, ["~> 0.11"])
    else
      s.add_dependency(%q<httpi>, ["~> 1.0"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<rspec>, ["~> 2.10"])
      s.add_dependency(%q<mocha>, ["~> 0.11"])
    end
  else
    s.add_dependency(%q<httpi>, ["~> 1.0"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<rspec>, ["~> 2.10"])
    s.add_dependency(%q<mocha>, ["~> 0.11"])
  end
end
