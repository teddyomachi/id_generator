# -*- encoding: utf-8 -*-
# stub: cape 1.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "cape".freeze
  s.version = "1.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nils Jonsson".freeze]
  s.date = "2013-11-18"
  s.description = "Cape dynamically generates Capistrano recipes for Rake tasks.\nIt provides a DSL for reflecting on Rake tasks and mirroring\nthem as documented Capistrano recipes. You can pass Rake task\narguments via environment variables.".freeze
  s.email = ["cape@nilsjonsson.com".freeze]
  s.homepage = "http://njonsson.github.io/cape".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Dynamically generates Capistrano recipes for Rake tasks".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<appraisal>.freeze, ["~> 0"])
      s.add_development_dependency(%q<aruba>.freeze, ["~> 0"])
      s.add_development_dependency(%q<capistrano>.freeze, ["~> 2"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0.9.3"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2"])
      s.add_development_dependency(%q<json_pure>.freeze, [">= 0"])
    else
      s.add_dependency(%q<appraisal>.freeze, ["~> 0"])
      s.add_dependency(%q<aruba>.freeze, ["~> 0"])
      s.add_dependency(%q<capistrano>.freeze, ["~> 2"])
      s.add_dependency(%q<rake>.freeze, [">= 0.9.3"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2"])
      s.add_dependency(%q<json_pure>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<appraisal>.freeze, ["~> 0"])
    s.add_dependency(%q<aruba>.freeze, ["~> 0"])
    s.add_dependency(%q<capistrano>.freeze, ["~> 2"])
    s.add_dependency(%q<rake>.freeze, [">= 0.9.3"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2"])
    s.add_dependency(%q<json_pure>.freeze, [">= 0"])
  end
end
