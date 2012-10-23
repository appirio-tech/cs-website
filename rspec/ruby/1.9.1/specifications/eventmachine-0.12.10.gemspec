# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{eventmachine}
  s.version = "0.12.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Francis Cianfrocca}]
  s.date = %q{2009-10-25}
  s.description = %q{EventMachine implements a fast, single-threaded engine for arbitrary network
communications. It's extremely easy to use in Ruby. EventMachine wraps all
interactions with IP sockets, allowing programs to concentrate on the
implementation of network protocols. It can be used to create both network
servers and clients. To create a server or client, a Ruby program only needs
to specify the IP address and port, and provide a Module that implements the
communications protocol. Implementations of several standard network protocols
are provided with the package, primarily to serve as examples. The real goal
of EventMachine is to enable programs to easily interface with other programs
using TCP/IP, especially if custom protocols are required.
}
  s.email = %q{garbagecat10@gmail.com}
  s.extensions = [%q{ext/extconf.rb}, %q{ext/fastfilereader/extconf.rb}]
  s.files = [%q{ext/extconf.rb}, %q{ext/fastfilereader/extconf.rb}]
  s.homepage = %q{http://rubyeventmachine.com}
  s.rdoc_options = [%q{--title}, %q{EventMachine}, %q{--main}, %q{README}, %q{--line-numbers}, %q{-x}, %q{lib/em/version}, %q{-x}, %q{lib/emva}, %q{-x}, %q{lib/evma/}, %q{-x}, %q{lib/pr_eventmachine}, %q{-x}, %q{lib/jeventmachine}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{eventmachine}
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Ruby/EventMachine library}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
