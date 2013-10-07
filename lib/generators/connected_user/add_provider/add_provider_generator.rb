require 'rails/generators/active_record'
require 'pp'

module ConnectedUser
  module Generators
    class AddProviderGenerator < ActiveRecord::Generators::Base
      desc "install connected_user user model"
      argument :name, type: :string

      def self.source_root
        @_connected_user_source_root ||= File.expand_path("../templates", __FILE__)
      end
      
      def copy_initializer
        name.gsub!(':','')

        # CHECK TO SEE IF konfigure.yml exists if it doesn't use konfigure:install to build it.
        konfig = "#{Rails.root}/config/konfigure.yml"
        unless File.exists?(konfig)
          generate("konfigure:install")
        end

        # ADD STRATEGEY GEM TO GEMFILE
        gem "omniauth-#{name}"
        Bundler.with_clean_env do
          run "bundle install"
        end
        # ADD STRATEGY TO INITIALIZER
        inject_into_file "config/initializers/omniauth.rb", "\n  provider :#{name.to_sym}, APP_CONFIG['#{name.to_s}_app_id'], APP_CONFIG['#{name.to_s}_app_secret']", :after => /provider :developer unless Rails.env.production\?*/

        # ADD stub CONFIG to APP CONFIG
        inject_into_file "config/konfigure.yml", "\n  #{name.to_s}_app_id : \n  #{name.to_s}_app_secret : ", :after => /defaults: &defaults*/
        
        # CREATE CONNECTION SUBCLASS FOR CONNECTION TYPE
        # check to see if we have a template for this connection type
        template 'provider_connection.rb.erb', "app/models/#{name.underscore}_connection.rb"
      end
      
      def create_migrations
      end
      
    end
  end
end

