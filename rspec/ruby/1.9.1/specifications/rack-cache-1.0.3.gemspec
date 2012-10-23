# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-cache}
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Ryan Tomayko}]
  s.date = %q{2011-08-27}
  s.description = %q{HTTP Caching for Rack}
  s.email = %q{r@tomayko.com}
  s.extra_rdoc_files = [%q{README}, %q{COPYING}, %q{TODO}, %q{CHANGES}]
  s.files = [%q{README}, %q{COPYING}, %q{TODO}, %q{CHANGES}]
  s.homepage = %q{http://tomayko.com/src/rack-cache/}
  s.rdoc_options = [%q{--line-numbers}, %q{--inline-source}, %q{--title}, %q{Rack::Cache}, %q{--main}, %q{Rack::Cache}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{HTTP Caching for Rack}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0.4"])
      s.add_development_dependency(%q<bacon>, [">= 0"])
      s.add_development_dependency(%q<memcached>, [">= 0"])
      s.add_development_dependency(%q<dalli>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0.4"])
      s.add_dependency(%q<bacon>, [">= 0"])
      s.add_dependency(%q<memcached>, [">= 0"])
      s.add_dependency(%q<dalli>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0.4"])
    s.add_dependency(%q<bacon>, [">= 0"])
    s.add_dependency(%q<memcached>, [">= 0"])
    s.add_dependency(%q<dalli>, [">= 0"])
  end
end
