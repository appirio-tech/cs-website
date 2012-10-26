# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{connection_pool}
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Mike Perham}]
  s.date = %q{2012-06-30}
  s.description = %q{Generic connection pool for Ruby}
  s.email = [%q{mperham@gmail.com}]
  s.homepage = %q{}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Generic connection pool for Ruby}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
