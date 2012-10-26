# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{airbrake}
  s.version = "3.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Airbrake}]
  s.date = %q{2012-10-23}
  s.email = %q{support@airbrake.io}
  s.executables = [%q{airbrake}]
  s.files = [%q{bin/airbrake}]
  s.homepage = %q{http://www.airbrake.io}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Send your application errors to our hosted service and reclaim your inbox.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_runtime_dependency(%q<girl_friday>, [">= 0"])
      s.add_development_dependency(%q<actionpack>, ["~> 2.3.8"])
      s.add_development_dependency(%q<activerecord>, ["~> 2.3.8"])
      s.add_development_dependency(%q<activesupport>, ["~> 2.3.8"])
      s.add_development_dependency(%q<mocha>, ["= 0.10.5"])
      s.add_development_dependency(%q<bourne>, [">= 1.0"])
      s.add_development_dependency(%q<cucumber>, ["~> 0.10.6"])
      s.add_development_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_development_dependency(%q<nokogiri>, ["~> 1.4.3.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<sham_rack>, ["~> 1.3.0"])
      s.add_development_dependency(%q<shoulda>, ["~> 2.11.3"])
      s.add_development_dependency(%q<capistrano>, ["~> 2.8.0"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-test>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<girl_friday>, [">= 0"])
      s.add_dependency(%q<actionpack>, ["~> 2.3.8"])
      s.add_dependency(%q<activerecord>, ["~> 2.3.8"])
      s.add_dependency(%q<activesupport>, ["~> 2.3.8"])
      s.add_dependency(%q<mocha>, ["= 0.10.5"])
      s.add_dependency(%q<bourne>, [">= 1.0"])
      s.add_dependency(%q<cucumber>, ["~> 0.10.6"])
      s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
      s.add_dependency(%q<nokogiri>, ["~> 1.4.3.1"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<sham_rack>, ["~> 1.3.0"])
      s.add_dependency(%q<shoulda>, ["~> 2.11.3"])
      s.add_dependency(%q<capistrano>, ["~> 2.8.0"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-test>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<girl_friday>, [">= 0"])
    s.add_dependency(%q<actionpack>, ["~> 2.3.8"])
    s.add_dependency(%q<activerecord>, ["~> 2.3.8"])
    s.add_dependency(%q<activesupport>, ["~> 2.3.8"])
    s.add_dependency(%q<mocha>, ["= 0.10.5"])
    s.add_dependency(%q<bourne>, [">= 1.0"])
    s.add_dependency(%q<cucumber>, ["~> 0.10.6"])
    s.add_dependency(%q<fakeweb>, ["~> 1.3.0"])
    s.add_dependency(%q<nokogiri>, ["~> 1.4.3.1"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<sham_rack>, ["~> 1.3.0"])
    s.add_dependency(%q<shoulda>, ["~> 2.11.3"])
    s.add_dependency(%q<capistrano>, ["~> 2.8.0"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-test>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end
