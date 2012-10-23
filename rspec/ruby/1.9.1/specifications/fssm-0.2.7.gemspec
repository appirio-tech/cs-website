# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fssm}
  s.version = "0.2.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Travis Tilley}, %q{Nathan Weizenbaum}, %q{Chris Eppstein}, %q{Jonathan Castello}, %q{Tuomas Kareinen}]
  s.date = %q{2011-04-21}
  s.description = %q{The File System State Monitor keeps track of the state of any number of paths and will fire events when said state changes (create/update/delete). FSSM supports using FSEvents on MacOS, Inotify on GNU/Linux, and polling anywhere else.}
  s.email = [%q{ttilley@gmail.com}]
  s.homepage = %q{https://github.com/ttilley/fssm}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{fssm}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{File System State Monitor}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2.4.0"])
    else
      s.add_dependency(%q<rspec>, [">= 2.4.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.4.0"])
  end
end
