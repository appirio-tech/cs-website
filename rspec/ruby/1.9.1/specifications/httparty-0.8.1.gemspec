# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{httparty}
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{John Nunemaker}, %q{Sandro Turriate}]
  s.date = %q{2011-10-05}
  s.description = %q{Makes http fun! Also, makes consuming restful web services dead easy.}
  s.email = [%q{nunemaker@gmail.com}]
  s.executables = [%q{httparty}]
  s.files = [%q{bin/httparty}]
  s.homepage = %q{http://httparty.rubyforge.org/}
  s.post_install_message = %q{When you HTTParty, you must party hard!}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Makes http fun! Also, makes consuming restful web services dead easy.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<multi_json>, [">= 0"])
      s.add_runtime_dependency(%q<multi_xml>, [">= 0"])
    else
      s.add_dependency(%q<multi_json>, [">= 0"])
      s.add_dependency(%q<multi_xml>, [">= 0"])
    end
  else
    s.add_dependency(%q<multi_json>, [">= 0"])
    s.add_dependency(%q<multi_xml>, [">= 0"])
  end
end
