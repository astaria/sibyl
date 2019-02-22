$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sibyl/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sibyl"
  s.version     = Sibyl::VERSION
  s.authors     = ["Janet jeffus"]
  s.email       = ["jjeffus@gmail.com"]
  s.homepage    = "https://github.com/astaria/sibyl"
  s.summary     = "An MVC Rails engine for filling out PDFs."
  s.description = "A super easy way to fill out a PDF form from a Rails application."
  s.license     = "GPL"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "> 5.0.0"
  s.add_dependency "rmagick", "~> 2.16.0"
  s.add_dependency "awesome_print"
  s.add_dependency "rubyzip"
  s.add_dependency "launchy"
  s.add_dependency "prawn"
  s.add_dependency "thor-rails"

  s.add_development_dependency "sqlite3"
end
