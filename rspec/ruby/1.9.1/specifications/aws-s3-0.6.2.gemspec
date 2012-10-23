# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{aws-s3}
  s.version = "0.6.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Marcel Molina Jr.}]
  s.date = %q{2009-04-28}
  s.description = %q{Client library for Amazon's Simple Storage Service's REST API}
  s.email = %q{marcel@vernix.org}
  s.executables = [%q{s3sh}]
  s.extra_rdoc_files = [%q{README}, %q{COPYING}, %q{INSTALL}]
  s.files = [%q{bin/s3sh}, %q{README}, %q{COPYING}, %q{INSTALL}]
  s.homepage = %q{http://amazon.rubyforge.org}
  s.rdoc_options = [%q{--title}, %q{AWS::S3 -- Support for Amazon S3's REST api}, %q{--main}, %q{README}, %q{--line-numbers}, %q{--inline-source}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{amazon}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Client library for Amazon's Simple Storage Service's REST API}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<xml-simple>, [">= 0"])
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_runtime_dependency(%q<mime-types>, [">= 0"])
    else
      s.add_dependency(%q<xml-simple>, [">= 0"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<mime-types>, [">= 0"])
    end
  else
    s.add_dependency(%q<xml-simple>, [">= 0"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<mime-types>, [">= 0"])
  end
end
