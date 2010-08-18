# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{drop_folders}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["ank"]
  s.date = %q{2010-08-18}
  s.default_executable = %q{drop_folders}
  s.description = %q{A simple web app built with sinatra to automate handbrake video conversion}
  s.email = %q{adamnkraut@gmail.com}
  s.executables = ["drop_folders"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/drop_folders",
     "config.yml",
     "lib/convert_job.rb",
     "lib/drop_folders.rb",
     "lib/drop_folders/config.ru",
     "lib/drop_folders/views/index.erb",
     "lib/drop_folders/views/layout.erb",
     "lib/drop_folders/views/show.erb",
     "test/helper.rb",
     "test/test_drop_folders.rb"
  ]
  s.homepage = %q{http://github.com/ank/drop_folders}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{web app to automate handbrake video conversion}
  s.test_files = [
    "test/test_drop_folders.rb",
     "test/helper.rb"
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

