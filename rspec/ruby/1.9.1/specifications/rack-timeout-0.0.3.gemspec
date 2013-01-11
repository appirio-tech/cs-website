# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-timeout}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Caio Chassot}]
  s.date = %q{2011-07-13}
  s.email = %q{dev@caiochassot.com}
  s.homepage = %q{http://github.com/kch/rack-timeout}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Abort requests that are taking too long}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
