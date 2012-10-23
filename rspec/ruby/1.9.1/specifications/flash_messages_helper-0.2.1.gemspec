# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{flash_messages_helper}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Michael Deering}]
  s.date = %q{2011-03-19}
  s.email = %q{mdeering@mdeering.com}
  s.extra_rdoc_files = [%q{README.textile}]
  s.files = [%q{README.textile}]
  s.homepage = %q{http://github.com/mdeering/flash_messages_helper}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{A simple yet configurable rails view helper for displaying flash messages.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rails>, ["< 3.0"])
      s.add_development_dependency(%q<rspec>, ["< 2.0"])
    else
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rails>, ["< 3.0"])
      s.add_dependency(%q<rspec>, ["< 2.0"])
    end
  else
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rails>, ["< 3.0"])
    s.add_dependency(%q<rspec>, ["< 2.0"])
  end
end
