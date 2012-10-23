# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{omniauth}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Michael Bleigh}, %q{Erik Michaels-Ober}]
  s.date = %q{2011-11-25}
  s.description = %q{A generalized Rack framework for multiple-provider authentication.}
  s.email = [%q{michael@intridea.com}, %q{sferik@gmail.com}]
  s.homepage = %q{http://github.com/intridea/omniauth}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{A generalized Rack framework for multiple-provider authentication.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_runtime_dependency(%q<hashie>, ["~> 1.2"])
      s.add_development_dependency(%q<maruku>, ["~> 0.6"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_development_dependency(%q<rack-test>, ["~> 0.5"])
      s.add_development_dependency(%q<rake>, ["~> 0.8"])
      s.add_development_dependency(%q<rdiscount>, ["~> 1.6"])
      s.add_development_dependency(%q<rspec>, ["~> 2.7"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<hashie>, ["~> 1.2"])
      s.add_dependency(%q<maruku>, ["~> 0.6"])
      s.add_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_dependency(%q<rack-test>, ["~> 0.5"])
      s.add_dependency(%q<rake>, ["~> 0.8"])
      s.add_dependency(%q<rdiscount>, ["~> 1.6"])
      s.add_dependency(%q<rspec>, ["~> 2.7"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<hashie>, ["~> 1.2"])
    s.add_dependency(%q<maruku>, ["~> 0.6"])
    s.add_dependency(%q<simplecov>, ["~> 0.4"])
    s.add_dependency(%q<rack-test>, ["~> 0.5"])
    s.add_dependency(%q<rake>, ["~> 0.8"])
    s.add_dependency(%q<rdiscount>, ["~> 1.6"])
    s.add_dependency(%q<rspec>, ["~> 2.7"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
  end
end
