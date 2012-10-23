# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{recaptcha}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jason L. Perry}]
  s.date = %q{2010-12-20}
  s.description = %q{This plugin adds helpers for the reCAPTCHA API }
  s.email = %q{jasper@ambethia.com}
  s.extra_rdoc_files = [%q{LICENSE}, %q{README.rdoc}]
  s.files = [%q{LICENSE}, %q{README.rdoc}]
  s.homepage = %q{http://ambethia.com/recaptcha}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Helpers for the reCAPTCHA API}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end
