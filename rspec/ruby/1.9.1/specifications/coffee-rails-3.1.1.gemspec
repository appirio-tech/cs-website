# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{coffee-rails}
  s.version = "3.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Santiago Pastorino}]
  s.date = %q{2011-09-13}
  s.description = %q{Coffee Script adapter for the Rails asset pipeline.}
  s.email = [%q{santiago@wyeworks.com}]
  s.homepage = %q{}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{coffee-rails}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Coffee Script adapter for the Rails asset pipeline.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<coffee-script>, [">= 2.2.0"])
      s.add_runtime_dependency(%q<railties>, ["~> 3.1.0"])
    else
      s.add_dependency(%q<coffee-script>, [">= 2.2.0"])
      s.add_dependency(%q<railties>, ["~> 3.1.0"])
    end
  else
    s.add_dependency(%q<coffee-script>, [">= 2.2.0"])
    s.add_dependency(%q<railties>, ["~> 3.1.0"])
  end
end
