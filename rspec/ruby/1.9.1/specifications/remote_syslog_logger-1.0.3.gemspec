# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{remote_syslog_logger}
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Eric Lindvall}]
  s.date = %q{2011-06-06}
  s.description = %q{A ruby Logger that sends UDP directly to a remote syslog endpoint}
  s.email = %q{eric@5stops.com}
  s.extra_rdoc_files = [%q{README.md}, %q{LICENSE}]
  s.files = [%q{README.md}, %q{LICENSE}]
  s.homepage = %q{https://github.com/papertrail/remote_syslog_logger}
  s.rdoc_options = [%q{--charset=UTF-8}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Ruby Logger that sends directly to a remote syslog endpoint}

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<syslog_protocol>, [">= 0"])
    else
      s.add_dependency(%q<syslog_protocol>, [">= 0"])
    end
  else
    s.add_dependency(%q<syslog_protocol>, [">= 0"])
  end
end
