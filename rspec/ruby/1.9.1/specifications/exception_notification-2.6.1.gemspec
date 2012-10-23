# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{exception_notification}
  s.version = "2.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jamis Buck}, %q{Josh Peek}]
  s.date = %q{2012-04-21}
  s.email = %q{smartinez87@gmail.com}
  s.homepage = %q{http://smartinez87.github.com/exception_notification}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Exception notification by email for Rails apps}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionmailer>, [">= 3.0.4"])
      s.add_development_dependency(%q<rails>, [">= 3.0.4"])
      s.add_development_dependency(%q<sqlite3>, [">= 1.3.4"])
    else
      s.add_dependency(%q<actionmailer>, [">= 3.0.4"])
      s.add_dependency(%q<rails>, [">= 3.0.4"])
      s.add_dependency(%q<sqlite3>, [">= 1.3.4"])
    end
  else
    s.add_dependency(%q<actionmailer>, [">= 3.0.4"])
    s.add_dependency(%q<rails>, [">= 3.0.4"])
    s.add_dependency(%q<sqlite3>, [">= 1.3.4"])
  end
end
