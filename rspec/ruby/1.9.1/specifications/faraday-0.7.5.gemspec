# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{faraday}
  s.version = "0.7.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Rick Olson}]
  s.date = %q{2011-10-04}
  s.description = %q{HTTP/REST API client library.}
  s.email = %q{technoweenie@gmail.com}
  s.homepage = %q{http://github.com/technoweenie/faraday}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{faraday}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{HTTP/REST API client library.}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<addressable>, ["~> 2.2.6"])
      s.add_runtime_dependency(%q<multipart-post>, ["~> 1.1.3"])
      s.add_runtime_dependency(%q<rack>, ["< 2", ">= 1.1.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<test-unit>, ["~> 2.4"])
      s.add_development_dependency(%q<webmock>, ["~> 1.7"])
    else
      s.add_dependency(%q<addressable>, ["~> 2.2.6"])
      s.add_dependency(%q<multipart-post>, ["~> 1.1.3"])
      s.add_dependency(%q<rack>, ["< 2", ">= 1.1.0"])
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<test-unit>, ["~> 2.4"])
      s.add_dependency(%q<webmock>, ["~> 1.7"])
    end
  else
    s.add_dependency(%q<addressable>, ["~> 2.2.6"])
    s.add_dependency(%q<multipart-post>, ["~> 1.1.3"])
    s.add_dependency(%q<rack>, ["< 2", ">= 1.1.0"])
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<test-unit>, ["~> 2.4"])
    s.add_dependency(%q<webmock>, ["~> 1.7"])
  end
end
