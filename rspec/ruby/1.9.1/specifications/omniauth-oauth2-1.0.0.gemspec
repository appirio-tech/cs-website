# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{omniauth-oauth2}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Michael Bleigh}]
  s.date = %q{2011-11-02}
  s.description = %q{An abstract OAuth2 strategy for OmniAuth.}
  s.email = [%q{michael@intridea.com}]
  s.homepage = %q{https://github.com/intridea/omniauth-oauth2}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{An abstract OAuth2 strategy for OmniAuth.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth>, ["~> 1.0"])
      s.add_runtime_dependency(%q<oauth2>, ["~> 0.5.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<omniauth>, ["~> 1.0"])
      s.add_dependency(%q<oauth2>, ["~> 0.5.0"])
      s.add_dependency(%q<rspec>, ["~> 2.7"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<omniauth>, ["~> 1.0"])
    s.add_dependency(%q<oauth2>, ["~> 0.5.0"])
    s.add_dependency(%q<rspec>, ["~> 2.7"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end
