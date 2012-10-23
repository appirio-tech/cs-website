# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-expectations}
  s.version = "2.11.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Steven Baker}, %q{David Chelimsky}]
  s.date = %q{2012-09-05}
  s.description = %q{rspec expectations (should[_not] and matchers)}
  s.email = %q{rspec-users@rubyforge.org}
  s.homepage = %q{http://github.com/rspec/rspec-expectations}
  s.licenses = [%q{MIT}]
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{rspec}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{rspec-expectations-2.11.3}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<diff-lcs>, ["~> 1.1.3"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_development_dependency(%q<cucumber>, ["~> 1.1.9"])
      s.add_development_dependency(%q<aruba>, ["~> 0.4.11"])
    else
      s.add_dependency(%q<diff-lcs>, ["~> 1.1.3"])
      s.add_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_dependency(%q<cucumber>, ["~> 1.1.9"])
      s.add_dependency(%q<aruba>, ["~> 0.4.11"])
    end
  else
    s.add_dependency(%q<diff-lcs>, ["~> 1.1.3"])
    s.add_dependency(%q<rake>, ["~> 0.9.2"])
    s.add_dependency(%q<cucumber>, ["~> 1.1.9"])
    s.add_dependency(%q<aruba>, ["~> 0.4.11"])
  end
end
