# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{omniauth-salesforce}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Richard Vanhook}]
  s.date = %q{2011-11-08}
  s.description = %q{OmniAuth strategy for salesforce.com.}
  s.email = [%q{rvanhook@salesforce.com}]
  s.homepage = %q{https://github.com/richardvanhook/omniauth-salesforce}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{OmniAuth strategy for salesforce.com.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth>, ["~> 1.0"])
      s.add_runtime_dependency(%q<omniauth-oauth2>, ["~> 1.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<omniauth>, ["~> 1.0"])
      s.add_dependency(%q<omniauth-oauth2>, ["~> 1.0"])
      s.add_dependency(%q<rspec>, ["~> 2.7"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<omniauth>, ["~> 1.0"])
    s.add_dependency(%q<omniauth-oauth2>, ["~> 1.0"])
    s.add_dependency(%q<rspec>, ["~> 2.7"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end
