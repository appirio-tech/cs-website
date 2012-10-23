# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{encryptor}
  s.version = "1.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Sean Huber}]
  s.date = %q{2011-04-12}
  s.description = %q{A simple wrapper for the standard ruby OpenSSL library to encrypt and decrypt strings}
  s.email = %q{shuber@huberry.com}
  s.homepage = %q{http://github.com/shuber/encryptor}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{A simple wrapper for the standard ruby OpenSSL library}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
