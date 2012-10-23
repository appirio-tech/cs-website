# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pg}
  s.version = "0.11.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Jeff Davis}, %q{Michael Granger}]
  s.cert_chain = [%q{-----BEGIN CERTIFICATE-----
MIIDLDCCAhSgAwIBAgIBADANBgkqhkiG9w0BAQUFADA8MQwwCgYDVQQDDANnZWQx
FzAVBgoJkiaJk/IsZAEZFgdfYWVyaWVfMRMwEQYKCZImiZPyLGQBGRYDb3JnMB4X
DTEwMDkxNjE0NDg1MVoXDTExMDkxNjE0NDg1MVowPDEMMAoGA1UEAwwDZ2VkMRcw
FQYKCZImiZPyLGQBGRYHX2FlcmllXzETMBEGCgmSJomT8ixkARkWA29yZzCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALy//BFxC1f/cPSnwtJBWoFiFrir
h7RicI+joq/ocVXQqI4TDWPyF/8tqkvt+rD99X9qs2YeR8CU/YiIpLWrQOYST70J
vDn7Uvhb2muFVqq6+vobeTkILBEO6pionWDG8jSbo3qKm1RjKJDwg9p4wNKhPuu8
KGue/BFb67KflqyApPmPeb3Vdd9clspzqeFqp7cUBMEpFS6LWxy4Gk+qvFFJBJLB
BUHE/LZVJMVzfpC5Uq+QmY7B+FH/QqNndn3tOHgsPadLTNimuB1sCuL1a4z3Pepd
TeLBEFmEao5Dk3K/Q8o8vlbIB/jBDTUx6Djbgxw77909x6gI9doU4LD5XMcCAwEA
AaM5MDcwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0OBBYEFJeoGkOr9l4B
+saMkW/ZXT4UeSvVMA0GCSqGSIb3DQEBBQUAA4IBAQBG2KObvYI2eHyyBUJSJ3jN
vEnU3d60znAXbrSd2qb3r1lY1EPDD3bcy0MggCfGdg3Xu54z21oqyIdk8uGtWBPL
HIa9EgfFGSUEgvcIvaYqiN4jTUtidfEFw+Ltjs8AP9gWgSIYS6Gr38V0WGFFNzIH
aOD2wmu9oo/RffW4hS/8GuvfMzcw7CQ355wFR4KB/nyze+EsZ1Y5DerCAagMVuDQ
U0BLmWDFzPGGWlPeQCrYHCr+AcJz+NRnaHCKLZdSKj/RHuTOt+gblRex8FAh8NeA
cmlhXe46pZNJgWKbxZah85jIjx95hR8vOI+NAM5iH9kOqK13DrxacTKPhqj5PjwF
-----END CERTIFICATE-----
}]
  s.date = %q{2011-04-19}
  s.description = %q{This is the extension library to access a PostgreSQL database from Ruby.
This library works with PostgreSQL 7.4 and later.}
  s.email = [%q{ruby-pg@j-davis.com}, %q{ged@FaerieMUD.org}]
  s.extensions = [%q{ext/extconf.rb}]
  s.extra_rdoc_files = [%q{ChangeLog}, %q{README}, %q{README.ja}, %q{README.OS_X}, %q{README.windows}, %q{LICENSE}]
  s.files = [%q{ChangeLog}, %q{README}, %q{README.ja}, %q{README.OS_X}, %q{README.windows}, %q{LICENSE}, %q{ext/extconf.rb}]
  s.homepage = %q{http://bitbucket.org/ged/ruby-pg/}
  s.licenses = [%q{Ruby}, %q{GPL}, %q{BSD}]
  s.rdoc_options = [%q{--tab-width=4}, %q{--show-hash}, %q{--include}, %q{.}, %q{--main=README}, %q{--title=pg}]
  s.require_paths = [%q{lib}, %q{ext}]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.requirements = [%q{PostgreSQL >=7.4}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{A Ruby interface to the PostgreSQL RDBMS}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
