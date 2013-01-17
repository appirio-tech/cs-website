# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{awesome_print}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Michael Dvorkin}]
  s.date = %q{2012-09-11}
  s.description = %q{Great Ruby dubugging companion: pretty print Ruby objects to visualize their structure. Supports custom object formatting via plugins}
  s.email = %q{mike@dvorkin.net}
  s.homepage = %q{http://github.com/michaeldv/awesome_print}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{awesome_print}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Pretty print Ruby objects with proper indentation and colors}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2.6.0"])
      s.add_development_dependency(%q<fakefs>, [">= 0.2.1"])
    else
      s.add_dependency(%q<rspec>, [">= 2.6.0"])
      s.add_dependency(%q<fakefs>, [">= 0.2.1"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.6.0"])
    s.add_dependency(%q<fakefs>, [">= 0.2.1"])
  end
end
