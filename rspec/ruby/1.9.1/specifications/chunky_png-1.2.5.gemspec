# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{chunky_png}
  s.version = "1.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Willem van Bergen}]
  s.date = %q{2011-09-23}
  s.description = %q{    This pure Ruby library can read and write PNG images without depending on an external 
    image library, like RMagick. It tries to be memory efficient and reasonably fast.
    
    It supports reading and writing all PNG variants that are defined in the specification, 
    with one limitation: only 8-bit color depth is supported. It supports all transparency, 
    interlacing and filtering options the PNG specifications allows. It can also read and 
    write textual metadata from PNG files. Low-level read/write access to PNG chunks is
    also possible.
    
    This library supports simple drawing on the image canvas and simple operations like
    alpha composition and cropping. Finally, it can import from and export to RMagick for 
    interoperability.
    
    Also, have a look at OilyPNG at http://github.com/wvanbergen/oily_png. OilyPNG is a 
    drop in mixin module that implements some of the ChunkyPNG algorithms in C, which 
    provides a massive speed boost to encoding and decoding.
}
  s.email = [%q{willem@railsdoctors.com}]
  s.extra_rdoc_files = [%q{README.rdoc}, %q{BENCHMARKS.rdoc}]
  s.files = [%q{README.rdoc}, %q{BENCHMARKS.rdoc}]
  s.homepage = %q{http://wiki.github.com/wvanbergen/chunky_png}
  s.rdoc_options = [%q{--title}, %q{chunky_png}, %q{--main}, %q{README.rdoc}, %q{--line-numbers}, %q{--inline-source}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Pure ruby library for read/write, chunk-level access to PNG files}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.2"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.2"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.2"])
  end
end
