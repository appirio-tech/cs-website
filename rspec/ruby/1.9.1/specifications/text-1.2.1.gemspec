# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{text}
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Paul Battley}, %q{Michael Neumann}, %q{Tim Fletcher}]
  s.date = %q{2012-06-10}
  s.description = %q{A collection of text algorithms: Levenshtein, Soundex, Metaphone, Double Metaphone, Porter Stemming}
  s.email = %q{pbattley@gmail.com}
  s.extra_rdoc_files = [%q{README.rdoc}]
  s.files = [%q{README.rdoc}]
  s.homepage = %q{http://github.com/threedaymonk/text}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{text}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{A collection of text algorithms}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
