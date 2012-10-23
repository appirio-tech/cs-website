# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-core}
  s.version = "2.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Chad Humphries}, %q{David Chelimsky}]
  s.bindir = %q{exe}
  s.date = %q{2011-10-20}
  s.description = %q{BDD for Ruby. RSpec runner and example groups.}
  s.email = %q{rspec-users@rubyforge.org;}
  s.executables = [%q{autospec}, %q{rspec}]
  s.extra_rdoc_files = [%q{README.md}]
  s.files = [%q{exe/autospec}, %q{exe/rspec}, %q{README.md}]
  s.homepage = %q{http://github.com/rspec}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{rspec}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{rspec-core-2.7.1}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
