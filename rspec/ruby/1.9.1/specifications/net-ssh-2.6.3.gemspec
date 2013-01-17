# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{net-ssh}
  s.version = "2.6.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jamis Buck}, %q{Delano Mandelbaum}]
  s.date = %q{2013-01-10}
  s.description = %q{Net::SSH: a pure-Ruby implementation of the SSH2 client protocol. It allows you to write programs that invoke and interact with processes on remote servers, via SSH2.}
  s.email = [%q{net-ssh@solutious.com}]
  s.extra_rdoc_files = [%q{README.rdoc}, %q{THANKS.rdoc}, %q{CHANGELOG.rdoc}]
  s.files = [%q{README.rdoc}, %q{THANKS.rdoc}, %q{CHANGELOG.rdoc}]
  s.homepage = %q{http://github.com/net-ssh/net-ssh}
  s.rdoc_options = [%q{--line-numbers}, %q{--title}, %q{Net::SSH: a pure-Ruby implementation of the SSH2 client protocol.}, %q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{net-ssh}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Net::SSH: a pure-Ruby implementation of the SSH2 client protocol.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<test-unit>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<test-unit>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<test-unit>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
