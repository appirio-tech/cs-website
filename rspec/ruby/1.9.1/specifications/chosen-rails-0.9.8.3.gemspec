# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{chosen-rails}
  s.version = "0.9.8.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Tse-Ching Ho}]
  s.date = %q{2012-09-07}
  s.description = %q{Chosen is a javascript library of select box enhancer for jQuery and Protoype. This gem integrates Chosen with Rails asset pipeline for easy of use.}
  s.email = [%q{tsechingho@gmail.com}]
  s.homepage = %q{https://github.com/tsechingho/chosen-rails}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Integrate Chosen javascript library with Rails asset pipeline}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, ["~> 3.0"])
      s.add_runtime_dependency(%q<thor>, ["~> 0.14"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<rails>, ["~> 3.0"])
      s.add_development_dependency(%q<sass>, ["~> 3.1"])
    else
      s.add_dependency(%q<railties>, ["~> 3.0"])
      s.add_dependency(%q<thor>, ["~> 0.14"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<rails>, ["~> 3.0"])
      s.add_dependency(%q<sass>, ["~> 3.1"])
    end
  else
    s.add_dependency(%q<railties>, ["~> 3.0"])
    s.add_dependency(%q<thor>, ["~> 0.14"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<rails>, ["~> 3.0"])
    s.add_dependency(%q<sass>, ["~> 3.1"])
  end
end
