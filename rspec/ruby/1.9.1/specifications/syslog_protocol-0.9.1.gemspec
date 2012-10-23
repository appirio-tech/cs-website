# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{syslog_protocol}
  s.version = "0.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jake Douglas}, %q{Eric Lindvall}]
  s.date = %q{2009-08-01}
  s.description = %q{Syslog protocol parser and generator}
  s.email = [%q{jakecdouglas@gmail.com}, %q{eric@5stops.com}]
  s.extra_rdoc_files = [%q{README.md}]
  s.files = [%q{README.md}]
  s.homepage = %q{https://github.com/eric/syslog_protocol}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Syslog protocol parser and generator}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bacon>, ["~> 1.1.0"])
    else
      s.add_dependency(%q<bacon>, ["~> 1.1.0"])
    end
  else
    s.add_dependency(%q<bacon>, ["~> 1.1.0"])
  end
end
