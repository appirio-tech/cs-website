# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{redis}
  s.version = "2.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Ezra Zygmuntowicz}, %q{Taylor Weibley}, %q{Matthew Clark}, %q{Brian McKinney}, %q{Salvatore Sanfilippo}, %q{Luca Guidi}, %q{Michel Martens}, %q{Damian Janowski}, %q{Pieter Noordhuis}]
  s.autorequire = %q{redis}
  s.date = %q{2011-08-03}
  s.description = %q{Ruby client library for Redis, the key value storage server}
  s.email = %q{ez@engineyard.com}
  s.homepage = %q{http://github.com/ezmobius/redis-rb}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{redis-rb}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Ruby client library for Redis, the key value storage server}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
