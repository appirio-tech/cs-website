# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nest}
  s.version = "1.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Michel Martens}]
  s.date = %q{2012-10-01}
  s.description = %q{It is a design pattern in key-value databases to use the key to simulate structure, and Nest can take care of that.}
  s.email = [%q{michel@soveran.com}]
  s.homepage = %q{http://github.com/soveran/nest}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Object-oriented keys for Redis.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<redis>, [">= 0"])
      s.add_development_dependency(%q<cutest>, [">= 0"])
    else
      s.add_dependency(%q<redis>, [">= 0"])
      s.add_dependency(%q<cutest>, [">= 0"])
    end
  else
    s.add_dependency(%q<redis>, [">= 0"])
    s.add_dependency(%q<cutest>, [">= 0"])
  end
end
