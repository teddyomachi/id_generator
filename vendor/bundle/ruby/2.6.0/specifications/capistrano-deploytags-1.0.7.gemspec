# -*- encoding: utf-8 -*-
# stub: capistrano-deploytags 1.0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "capistrano-deploytags".freeze
  s.version = "1.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Karl Matthias".freeze, "Gavin Heavyside".freeze]
  s.date = "2017-02-07"
  s.description = "  Capistrano Deploytags is a simple plugin to Capistrano 3 that works with your deployment framework to track your code releases. All you have to do is require capistrano-deploytags/capistrano and each deployment will add a new tag for that deployment, pointing to the latest commit. This lets you easily see which code is deployed on each environment, and allows you to figure out which code was running in an environment at any time in the past.\n".freeze
  s.email = ["relistan@gmail.com".freeze, "gavin.heavyside@mydrivesolutions.com".freeze]
  s.homepage = "http://github.com/mydrive/capistrano-deploytags".freeze
  s.licenses = ["BSD-2-Clause".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Add dated, environment-specific tags to your git repo at each deployment.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>.freeze, [">= 3.7.0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
    else
      s.add_dependency(%q<capistrano>.freeze, [">= 3.7.0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
    end
  else
    s.add_dependency(%q<capistrano>.freeze, [">= 3.7.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0.0"])
  end
end
