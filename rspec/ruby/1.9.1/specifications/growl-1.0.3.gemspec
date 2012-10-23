# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{growl}
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{TJ Holowaychuk}]
  s.date = %q{2009-07-25}
  s.description = %q{growlnotify bindings}
  s.email = %q{tj@vision-media.ca}
  s.extra_rdoc_files = [%q{lib/growl/growl.rb}, %q{lib/growl/images/error.png}, %q{lib/growl/images/info.png}, %q{lib/growl/images/ok.png}, %q{lib/growl/images/warning.png}, %q{lib/growl/version.rb}, %q{lib/growl.rb}, %q{README.rdoc}, %q{tasks/docs.rake}, %q{tasks/gemspec.rake}, %q{tasks/spec.rake}]
  s.files = [%q{lib/growl/growl.rb}, %q{lib/growl/images/error.png}, %q{lib/growl/images/info.png}, %q{lib/growl/images/ok.png}, %q{lib/growl/images/warning.png}, %q{lib/growl/version.rb}, %q{lib/growl.rb}, %q{README.rdoc}, %q{tasks/docs.rake}, %q{tasks/gemspec.rake}, %q{tasks/spec.rake}]
  s.homepage = %q{http://github.com/visionmedia/growl}
  s.rdoc_options = [%q{--line-numbers}, %q{--inline-source}, %q{--title}, %q{Growl}, %q{--main}, %q{README.rdoc}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{growl}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{growlnotify bindings}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
