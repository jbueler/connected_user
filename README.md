Connected User
=============

Creates User model, Connection Model. Adds helpers for adding auth providers (omniauth strategies).

### Installation

This gem will create your user model, and all of the additional models needed to authenticate against multiple social networks. It can also create the SessionController for you with stubbed in functionality for loging in and out. You must have a root route for this to work out of the box, also it would be best that you have your database created ahead of time.

	gem 'konfigure', git: 'git@github.com:roundhouse/konfigure.git' # this is now a requirement for connected_user
	gem 'connected_user', :git => 'git@github.com:roundhouse/connected_user.git'

then `bundle install`. After you have the gems installed you can run `rails g connected_user:install`. Follow the terminal prompt for additionaly configurations.

now `rake db:migrate`, this will create the user model tables and the appropriate tables for managing the connected social accounts. You should be able to login with the added developer strategy. `http://localhost:3000\auth\developer` fill out the form ... and boom. User, connection and logged in...


### Adding providers

`rails g connected_user:add_provider :facebook`

this will create the connection subclass `FacebookConnection < Connection`, it will add the best guess for the strategy gem to the gemfile `omniauth-facebook`, it will add the provider to the omniauth.rb file `provider :facebook, APP_CONFIG['facebook_app_id'], APP_CONFIG['facebook_app_secret']` and lastly it will stub in the configuration keys in your APP_CONFIG (this is where the `konfigure` gem comes into play). [Konfigure](git@github.com:roundhouse/konfigure.git) will create your konfigure.yml (formerly config.yml). Then we will continue with adding the provider keys to that file.
