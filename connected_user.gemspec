# encoding: utf-8
require File.expand_path("../lib/connected_user/version", __FILE__)

Gem::Specification.new do |s|
  s.name              = "connected_user"
  s.version           = ConnectedUser::VERSION
  s.authors           = ["Jeremy Bueler"]
  s.email             = ["jbueler@gmail.com"]
  s.homepage          = "https://github.com/jbueler/connected_user"
  s.summary           = "User model with Oath - Helps get you set up for third party authentication into your user model"
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test}/*`.split("\n")
  s.require_paths     = ["lib"]
  s.license           = 'MIT'

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'activerecord'
  s.add_dependency 'omniauth', '~> 1.0'

  s.description = <<-EOM
  User model with Oath - Helps get you set up for third party authentication into your user model. Adds generators and migrations for your models.
EOM
end