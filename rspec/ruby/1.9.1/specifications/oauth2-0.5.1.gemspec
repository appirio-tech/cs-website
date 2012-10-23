# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{oauth2}
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Michael Bleigh}, %q{Erik Michaels-Ober}]
  s.date = %q{2011-09-26}
  s.description = %q{A Ruby wrapper for the OAuth 2.0 protocol built with a similar style to the original OAuth gem.}
  s.email = [%q{michael@intridea.com}, %q{sferik@gmail.com}]
  s.homepage = %q{http://github.com/intridea/oauth2}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{A Ruby wrapper for the OAuth 2.0 protocol.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<faraday>, ["~> 0.7.4"])
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.0.3"])
      s.add_development_dependency(%q<multi_xml>, ["~> 0.4"])
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.9"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
    else
      s.add_dependency(%q<faraday>, ["~> 0.7.4"])
      s.add_dependency(%q<multi_json>, ["~> 1.0.3"])
      s.add_dependency(%q<multi_xml>, ["~> 0.4"])
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<rdoc>, ["~> 3.9"])
      s.add_dependency(%q<rspec>, ["~> 2.6"])
      s.add_dependency(%q<simplecov>, ["~> 0.4"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
    end
  else
    s.add_dependency(%q<faraday>, ["~> 0.7.4"])
    s.add_dependency(%q<multi_json>, ["~> 1.0.3"])
    s.add_dependency(%q<multi_xml>, ["~> 0.4"])
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<rdoc>, ["~> 3.9"])
    s.add_dependency(%q<rspec>, ["~> 2.6"])
    s.add_dependency(%q<simplecov>, ["~> 0.4"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
  end
end
