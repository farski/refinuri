# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{refinuri}
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Kalafarski"]
  s.date = %q{2010-02-08}
  s.description = %q{Helps clean up complex URLs with filtering query string, like you may find in an online store}
  s.email = %q{chris@farski.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md",
     "TODO"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.md",
     "Rakefile",
     "TODO",
     "VERSION",
     "lib/refinuri.rb",
     "lib/refinuri/base.rb",
     "lib/refinuri/filters.rb",
     "lib/refinuri/helpers.rb",
     "lib/refinuri/parser.rb",
     "lib/refinuri/query.rb",
     "lib/refinuri/utilities.rb",
     "refinuri-0.5.1.gem",
     "refinuri.gemspec",
     "test/helper.rb",
     "test/test_array_filters.rb",
     "test/test_helpers.rb",
     "test/test_parser.rb",
     "test/test_rails_integration.rb",
     "test/test_range_filters.rb",
     "test/test_refinuri.rb",
     "test/test_unbounded_range_filters.rb",
     "test/test_utilties.rb"
  ]
  s.homepage = %q{http://github.com/farski/refinuri}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Helps clean up complex URLs with filtering query string, like you may find in an online store}
  s.test_files = [
    "test/helper.rb",
     "test/test_array_filters.rb",
     "test/test_helpers.rb",
     "test/test_parser.rb",
     "test/test_rails_integration.rb",
     "test/test_range_filters.rb",
     "test/test_refinuri.rb",
     "test/test_unbounded_range_filters.rb",
     "test/test_utilties.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end

