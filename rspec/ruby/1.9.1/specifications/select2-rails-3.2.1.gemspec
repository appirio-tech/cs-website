# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{select2-rails}
  s.version = "3.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Rogerio Medeiros}, %q{Pedro Nascimento}]
  s.date = %q{2012-09-23}
  s.description = %q{Select2 is a jQuery based replacement for select boxes. It supports searching, remote data sets, and infinite scrolling of results. This gem integrates Select2 with Rails asset pipeline for easy of use.}
  s.email = [%q{argerim@gmail.com}, %q{pnascimento@gmail.com}]
  s.homepage = %q{https://github.com/argerim/select2-rails}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Integrate Select2 javascript library with Rails asset pipeline}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, ["~> 0.14"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<rails>, ["~> 3.0"])
      s.add_development_dependency(%q<httpclient>, ["~> 2.2"])
    else
      s.add_dependency(%q<thor>, ["~> 0.14"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<rails>, ["~> 3.0"])
      s.add_dependency(%q<httpclient>, ["~> 2.2"])
    end
  else
    s.add_dependency(%q<thor>, ["~> 0.14"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<rails>, ["~> 3.0"])
    s.add_dependency(%q<httpclient>, ["~> 2.2"])
  end
end
