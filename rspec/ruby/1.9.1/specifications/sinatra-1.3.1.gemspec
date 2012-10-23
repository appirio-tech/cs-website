# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra}
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Blake Mizerany}, %q{Ryan Tomayko}, %q{Simon Rozet}, %q{Konstantin Haase}]
  s.date = %q{2011-10-05}
  s.description = %q{Sinatra is a DSL for quickly creating web applications in Ruby with minimal effort.}
  s.email = %q{sinatrarb@googlegroups.com}
  s.extra_rdoc_files = [%q{README.de.rdoc}, %q{README.es.rdoc}, %q{README.fr.rdoc}, %q{README.hu.rdoc}, %q{README.jp.rdoc}, %q{README.pt-br.rdoc}, %q{README.pt-pt.rdoc}, %q{README.rdoc}, %q{README.ru.rdoc}, %q{README.zh.rdoc}, %q{LICENSE}]
  s.files = [%q{README.de.rdoc}, %q{README.es.rdoc}, %q{README.fr.rdoc}, %q{README.hu.rdoc}, %q{README.jp.rdoc}, %q{README.pt-br.rdoc}, %q{README.pt-pt.rdoc}, %q{README.rdoc}, %q{README.ru.rdoc}, %q{README.zh.rdoc}, %q{LICENSE}]
  s.homepage = %q{http://www.sinatrarb.com/}
  s.rdoc_options = [%q{--line-numbers}, %q{--inline-source}, %q{--title}, %q{Sinatra}, %q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Classy web-development dressed in a DSL}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 1.3.4", "~> 1.3"])
      s.add_runtime_dependency(%q<rack-protection>, [">= 1.1.2", "~> 1.1"])
      s.add_runtime_dependency(%q<tilt>, [">= 1.3.3", "~> 1.3"])
    else
      s.add_dependency(%q<rack>, [">= 1.3.4", "~> 1.3"])
      s.add_dependency(%q<rack-protection>, [">= 1.1.2", "~> 1.1"])
      s.add_dependency(%q<tilt>, [">= 1.3.3", "~> 1.3"])
    end
  else
    s.add_dependency(%q<rack>, [">= 1.3.4", "~> 1.3"])
    s.add_dependency(%q<rack-protection>, [">= 1.1.2", "~> 1.1"])
    s.add_dependency(%q<tilt>, [">= 1.3.3", "~> 1.3"])
  end
end
