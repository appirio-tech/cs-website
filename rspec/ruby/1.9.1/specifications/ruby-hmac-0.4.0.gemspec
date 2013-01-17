# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-hmac}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Daiki Ueno}, %q{Geoffrey Grosenbach}]
  s.date = %q{2010-01-20}
  s.description = %q{This module provides common interface to HMAC functionality. HMAC is a kind of "Message Authentication Code" (MAC) algorithm whose standard is documented in RFC2104. Namely, a MAC provides a way to check the integrity of information transmitted over or stored in an unreliable medium, based on a secret key.

Originally written by Daiki Ueno. Converted to a RubyGem by Geoffrey Grosenbach}
  s.email = [%q{}, %q{boss@topfunky.com}]
  s.extra_rdoc_files = [%q{History.txt}, %q{Manifest.txt}, %q{README.txt}]
  s.files = [%q{History.txt}, %q{Manifest.txt}, %q{README.txt}]
  s.homepage = %q{http://ruby-hmac.rubyforge.org}
  s.rdoc_options = [%q{--main}, %q{README.txt}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{ruby-hmac}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{This module provides common interface to HMAC functionality}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_development_dependency(%q<gemcutter>, [">= 0.2.1"])
      s.add_development_dependency(%q<hoe>, [">= 2.5.0"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_dependency(%q<gemcutter>, [">= 0.2.1"])
      s.add_dependency(%q<hoe>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
    s.add_dependency(%q<gemcutter>, [">= 0.2.1"])
    s.add_dependency(%q<hoe>, [">= 2.5.0"])
  end
end
