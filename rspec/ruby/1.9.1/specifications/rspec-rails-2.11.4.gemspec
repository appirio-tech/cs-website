# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-rails}
  s.version = "2.11.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{David Chelimsky}]
  s.date = %q{2012-10-14}
  s.description = %q{RSpec for Rails}
  s.email = %q{rspec-users@rubyforge.org}
  s.homepage = %q{http://github.com/rspec/rspec-rails}
  s.licenses = [%q{MIT}]
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{rspec}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{rspec-rails-2.11.4}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0"])
      s.add_runtime_dependency(%q<actionpack>, [">= 3.0"])
      s.add_runtime_dependency(%q<railties>, [">= 3.0"])
      s.add_runtime_dependency(%q<rspec>, ["~> 2.11.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_development_dependency(%q<cucumber>, ["~> 1.1.9"])
      s.add_development_dependency(%q<aruba>, ["~> 0.4.11"])
      s.add_development_dependency(%q<ZenTest>, ["= 4.6.2"])
      s.add_development_dependency(%q<ammeter>, ["= 0.2.5"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.0"])
      s.add_dependency(%q<actionpack>, [">= 3.0"])
      s.add_dependency(%q<railties>, [">= 3.0"])
      s.add_dependency(%q<rspec>, ["~> 2.11.0"])
      s.add_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_dependency(%q<cucumber>, ["~> 1.1.9"])
      s.add_dependency(%q<aruba>, ["~> 0.4.11"])
      s.add_dependency(%q<ZenTest>, ["= 4.6.2"])
      s.add_dependency(%q<ammeter>, ["= 0.2.5"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.0"])
    s.add_dependency(%q<actionpack>, [">= 3.0"])
    s.add_dependency(%q<railties>, [">= 3.0"])
    s.add_dependency(%q<rspec>, ["~> 2.11.0"])
    s.add_dependency(%q<rake>, ["~> 0.9.2"])
    s.add_dependency(%q<cucumber>, ["~> 1.1.9"])
    s.add_dependency(%q<aruba>, ["~> 0.4.11"])
    s.add_dependency(%q<ZenTest>, ["= 4.6.2"])
    s.add_dependency(%q<ammeter>, ["= 0.2.5"])
  end
end
