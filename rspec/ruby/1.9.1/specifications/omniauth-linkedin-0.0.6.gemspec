# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{omniauth-linkedin}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Alan Skorkin}]
  s.date = %q{2011-11-15}
  s.description = %q{LinkedIn strategy for OmniAuth.}
  s.email = [%q{alan@skorks.com}]
  s.homepage = %q{https://github.com/skorks/omniauth-linkedin}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{LinkedIn strategy for OmniAuth.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth-oauth>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
    else
      s.add_dependency(%q<omniauth-oauth>, ["~> 1.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.7.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
    end
  else
    s.add_dependency(%q<omniauth-oauth>, ["~> 1.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.7.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
  end
end
