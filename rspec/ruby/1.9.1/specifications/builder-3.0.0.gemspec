# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{builder}
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jim Weirich}]
  s.autorequire = %q{builder}
  s.date = %q{2010-11-17}
  s.description = %q{Builder provides a number of builder objects that make creating structured data
simple to do.  Currently the following builder objects are supported:

* XML Markup
* XML Events
}
  s.email = %q{jim@weirichhouse.org}
  s.extra_rdoc_files = [%q{CHANGES}, %q{Rakefile}, %q{README}, %q{README.rdoc}, %q{TAGS}, %q{doc/releases/builder-1.2.4.rdoc}, %q{doc/releases/builder-2.0.0.rdoc}, %q{doc/releases/builder-2.1.1.rdoc}]
  s.files = [%q{CHANGES}, %q{Rakefile}, %q{README}, %q{README.rdoc}, %q{TAGS}, %q{doc/releases/builder-1.2.4.rdoc}, %q{doc/releases/builder-2.0.0.rdoc}, %q{doc/releases/builder-2.1.1.rdoc}]
  s.homepage = %q{http://onestepback.org}
  s.rdoc_options = [%q{--title}, %q{Builder -- Easy XML Building}, %q{--main}, %q{README.rdoc}, %q{--line-numbers}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Builders for MarkUp.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
