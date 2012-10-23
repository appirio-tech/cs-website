# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hashie}
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Michael Bleigh}]
  s.date = %q{2011-10-15}
  s.description = %q{Hashie is a small collection of tools that make hashes more powerful. Currently includes Mash (Mocking Hash) and Dash (Discrete Hash).}
  s.email = [%q{michael@intridea.com}]
  s.homepage = %q{https://github.com/intridea/hashie}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Your friendly neighborhood hash toolkit.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_development_dependency(%q<rspec>, ["~> 2.5"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
    else
      s.add_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_dependency(%q<rspec>, ["~> 2.5"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 0.9.2"])
    s.add_dependency(%q<rspec>, ["~> 2.5"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
  end
end
