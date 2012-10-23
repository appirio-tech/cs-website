# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dalli}
  s.version = "2.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Mike Perham}]
  s.date = %q{2012-05-10}
  s.description = %q{High performance memcached client for Ruby}
  s.email = %q{mperham@gmail.com}
  s.homepage = %q{http://github.com/mperham/dalli}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{High performance memcached client for Ruby}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mini_shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rails>, ["~> 3"])
    else
      s.add_dependency(%q<mini_shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rails>, ["~> 3"])
    end
  else
    s.add_dependency(%q<mini_shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rails>, ["~> 3"])
  end
end
