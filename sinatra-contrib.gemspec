# Run `rake sinatra-contrib.gemspec` to update the gemspec.
Gem::Specification.new do |s|
  s.name        = "sinatra-contrib"
  s.version     = "1.4.0"
  s.description = "Collection of useful Sinatra extensions"
  s.homepage    = "http://github.com/sinatra/sinatra-contrib"
  s.summary     = s.description

  # generated from git shortlog -sn
  s.authors = [
    "Konstantin Haase",
    "Gabriel Andretta",
    "Nicolas Sanguinetti",
    "Eliot Shepard",
    "Andrew Crump",
    "Matt Lyon",
    "undr"
  ]

  # generated from git shortlog -sne
  s.email = [
    "konstantin.mailinglists@googlemail.com",
    "ohhgabriel@gmail.com",
    "contacto@nicolassanguinetti.info",
    "eshepard@slower.net",
    "andrew.crump@ieee.org",
    "matt@flowerpowered.com",
    "undr@yandex.ru"
  ]

  # generated from git ls-files
  s.files = [
    "LICENSE",
    "README.md",
    "Rakefile",
    "ideas.md",
    "lib/sinatra/capture.rb",
    "lib/sinatra/config_file.rb",
    "lib/sinatra/content_for.rb",
    "lib/sinatra/contrib.rb",
    "lib/sinatra/contrib/all.rb",
    "lib/sinatra/contrib/setup.rb",
    "lib/sinatra/contrib/version.rb",
    "lib/sinatra/cookies.rb",
    "lib/sinatra/decompile.rb",
    "lib/sinatra/engine_tracking.rb",
    "lib/sinatra/extension.rb",
    "lib/sinatra/json.rb",
    "lib/sinatra/link_header.rb",
    "lib/sinatra/multi_json.rb",
    "lib/sinatra/multi_route.rb",
    "lib/sinatra/namespace.rb",
    "lib/sinatra/reloader.rb",
    "lib/sinatra/respond_with.rb",
    "lib/sinatra/streaming.rb",
    "lib/sinatra/test_helpers.rb",
    "sinatra-contrib.gemspec",
    "spec/capture_spec.rb",
    "spec/config_file/key_value.yml",
    "spec/config_file/key_value.yml.erb",
    "spec/config_file/key_value_override.yml",
    "spec/config_file/missing_env.yml",
    "spec/config_file/with_envs.yml",
    "spec/config_file/with_nested_envs.yml",
    "spec/config_file_spec.rb",
    "spec/content_for/different_key.erb",
    "spec/content_for/different_key.erubis",
    "spec/content_for/different_key.haml",
    "spec/content_for/different_key.slim",
    "spec/content_for/layout.erb",
    "spec/content_for/layout.erubis",
    "spec/content_for/layout.haml",
    "spec/content_for/layout.slim",
    "spec/content_for/multiple_blocks.erb",
    "spec/content_for/multiple_blocks.erubis",
    "spec/content_for/multiple_blocks.haml",
    "spec/content_for/multiple_blocks.slim",
    "spec/content_for/multiple_yields.erb",
    "spec/content_for/multiple_yields.erubis",
    "spec/content_for/multiple_yields.haml",
    "spec/content_for/multiple_yields.slim",
    "spec/content_for/passes_values.erb",
    "spec/content_for/passes_values.erubis",
    "spec/content_for/passes_values.haml",
    "spec/content_for/passes_values.slim",
    "spec/content_for/same_key.erb",
    "spec/content_for/same_key.erubis",
    "spec/content_for/same_key.haml",
    "spec/content_for/same_key.slim",
    "spec/content_for/takes_values.erb",
    "spec/content_for/takes_values.erubis",
    "spec/content_for/takes_values.haml",
    "spec/content_for/takes_values.slim",
    "spec/content_for_spec.rb",
    "spec/cookies_spec.rb",
    "spec/decompile_spec.rb",
    "spec/extension_spec.rb",
    "spec/json_spec.rb",
    "spec/link_header_spec.rb",
    "spec/multi_json_spec.rb",
    "spec/multi_route_spec.rb",
    "spec/namespace/foo.erb",
    "spec/namespace/nested/foo.erb",
    "spec/namespace_spec.rb",
    "spec/okjson.rb",
    "spec/reloader/app.rb.erb",
    "spec/reloader_spec.rb",
    "spec/respond_with/bar.erb",
    "spec/respond_with/bar.json.erb",
    "spec/respond_with/foo.html.erb",
    "spec/respond_with/not_html.sass",
    "spec/respond_with_spec.rb",
    "spec/spec_helper.rb",
    "spec/streaming_spec.rb"
  ]

  s.add_dependency "sinatra",   "~> 1.4.0"
  s.add_dependency "backports", ">= 2.0"
  s.add_dependency "tilt",      "~> 1.3"
  s.add_dependency "multi_json"
  s.add_dependency "rack-test"
  s.add_dependency "rack-protection"
  s.add_dependency "eventmachine"

  s.add_development_dependency "rspec", "~> 2.3"
  s.add_development_dependency "haml"
  s.add_development_dependency "erubis"
  s.add_development_dependency "slim"
  s.add_development_dependency "rake"
end
