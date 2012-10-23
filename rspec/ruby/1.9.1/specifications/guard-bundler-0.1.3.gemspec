# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{guard-bundler}
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Yann Lugrin}]
  s.date = %q{2011-05-13}
  s.description = %q{Guard::Bundler automatically install/update your gem bundle when needed}
  s.email = [%q{yann.lugrin@sans-savoir.net}]
  s.homepage = %q{http://rubygems.org/gems/guard-bundler}
  s.rdoc_options = [%q{--charset=UTF-8}, %q{--main=README.rdoc}, %q{--exclude='(lib|test|spec)|(Gem|Guard|Rake)file'}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{guard-bundler}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Guard gem for Bundler}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<guard>, [">= 0.2.2"])
      s.add_runtime_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 0.3.1"])
    else
      s.add_dependency(%q<guard>, [">= 0.2.2"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<guard-rspec>, ["~> 0.3.1"])
    end
  else
    s.add_dependency(%q<guard>, [">= 0.2.2"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<guard-rspec>, ["~> 0.3.1"])
  end
end
