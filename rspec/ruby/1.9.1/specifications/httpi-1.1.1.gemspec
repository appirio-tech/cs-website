# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{httpi}
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Daniel Harrington}, %q{Martin Tepper}]
  s.date = %q{2012-07-01}
  s.description = %q{HTTPI provides a common interface for Ruby HTTP libraries.}
  s.email = %q{me@rubiii.com}
  s.homepage = %q{http://github.com/rubiii/httpi}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{httpi}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Interface for Ruby HTTP libraries}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9.9"])
      s.add_development_dependency(%q<webmock>, ["~> 1.4.0"])
      s.add_development_dependency(%q<autotest>, [">= 0"])
      s.add_development_dependency(%q<ZenTest>, ["= 4.5.0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_dependency(%q<rspec>, ["~> 2.7"])
      s.add_dependency(%q<mocha>, ["~> 0.9.9"])
      s.add_dependency(%q<webmock>, ["~> 1.4.0"])
      s.add_dependency(%q<autotest>, [">= 0"])
      s.add_dependency(%q<ZenTest>, ["= 4.5.0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<rake>, ["~> 0.8.7"])
    s.add_dependency(%q<rspec>, ["~> 2.7"])
    s.add_dependency(%q<mocha>, ["~> 0.9.9"])
    s.add_dependency(%q<webmock>, ["~> 1.4.0"])
    s.add_dependency(%q<autotest>, [">= 0"])
    s.add_dependency(%q<ZenTest>, ["= 4.5.0"])
  end
end
