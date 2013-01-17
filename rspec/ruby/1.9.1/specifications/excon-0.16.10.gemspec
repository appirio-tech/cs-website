# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{excon}
  s.version = "0.16.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{dpiddy (Dan Peterson)}, %q{geemus (Wesley Beary)}, %q{nextmat (Matt Sanders)}]
  s.date = %q{2012-11-16}
  s.description = %q{EXtended http(s) CONnections}
  s.email = %q{geemus@gmail.com}
  s.extra_rdoc_files = [%q{README.md}]
  s.files = [%q{README.md}]
  s.homepage = %q{https://github.com/geemus/excon}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{excon}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{speed, persistence, http(s)}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<delorean>, [">= 0"])
      s.add_development_dependency(%q<eventmachine>, [">= 0"])
      s.add_development_dependency(%q<open4>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<shindo>, [">= 0"])
      s.add_development_dependency(%q<sinatra>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<delorean>, [">= 0"])
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<open4>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<shindo>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<delorean>, [">= 0"])
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<open4>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<shindo>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
  end
end
