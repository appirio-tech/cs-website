# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{thin}
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Marc-Andre Cournoyer}]
  s.date = %q{2011-11-14}
  s.description = %q{A thin and fast web server}
  s.email = %q{macournoyer@gmail.com}
  s.executables = [%q{thin}]
  s.extensions = [%q{ext/thin_parser/extconf.rb}]
  s.files = [%q{bin/thin}, %q{ext/thin_parser/extconf.rb}]
  s.homepage = %q{http://code.macournoyer.com/thin/}
  s.require_paths = [%q{lib}]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.5")
  s.rubyforge_project = %q{thin}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{A thin and fast web server}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<eventmachine>, [">= 0.12.6"])
      s.add_runtime_dependency(%q<daemons>, [">= 1.0.9"])
    else
      s.add_dependency(%q<rack>, [">= 1.0.0"])
      s.add_dependency(%q<eventmachine>, [">= 0.12.6"])
      s.add_dependency(%q<daemons>, [">= 1.0.9"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.0.0"])
    s.add_dependency(%q<eventmachine>, [">= 0.12.6"])
    s.add_dependency(%q<daemons>, [">= 1.0.9"])
  end
end
