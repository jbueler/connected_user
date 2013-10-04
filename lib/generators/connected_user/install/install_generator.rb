require 'rails/generators/active_record'
require 'pp'

module ConnectedUser
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc "install connected_user user model"
      argument :name, type: :string, default: "User"

      def self.source_root
        @_connected_user_source_root ||= File.expand_path("../templates", __FILE__)
      end
      
      def copy_initializer
        @underscored_user_name = name.underscore
        template 'omniauth.rb.erb', 'config/initializers/omniauth.rb'
      end
      
      def create_migrations
        # model name
        template 'user_model.rb.erb', "app/models/#{@underscored_user_name}.rb"
        template 'connection_model.rb.erb', "app/models/connection.rb"
        migration_template 'migrations/create_connections_table.rb.erb', 'db/migrate/create_connections_table'
        migration_template 'migrations/create_connected_user_model.rb.erb', 'db/migrate/create_connected_user_model'
      end
      
    end
  end
end