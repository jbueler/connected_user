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
        
        if ask("Would you like to create a Session Controller? [y/n]").downcase == 'y'
          template 'session_controller.rb.erb', "app/controllers/session_controller.rb"
          
          # ADD CURRENT_USER HELPER
          inject_into_file 'app/controllers/application_controller.rb', :after => "protect_from_forgery with: :exception" do          
          <<-eos

  private
    def current_user
      @current_user ||= #{name}.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    def set_current_user (#{@underscored_user_name.downcase})
      if user
        @current_user = #{@underscored_user_name.downcase}
        session[:#{@underscored_user_name.downcase}_id] = @current_user.id
      else
        raise UserLoginError
      end
    end
          eos
          end
          inject_into_file 'app/controllers/application_controller.rb', "\n  skip_before_filter :verify_authenticity_token, :only => :create", :after => "protect_from_forgery with: :exception"
          # CREATE CONNECTION SUBCLASS FOR CONNECTION TYPE
          # check to see if we have a template for this connection type
          generate('connected_user:add_provider :developer')
          
          route_file = "config/routes.rb"
          inject_into_file route_file, "\n  get '/logout' => 'session#destroy', :as => :logout", :after => /Application.routes.draw do*/
          inject_into_file route_file, "\n  post '/auth/:provider/callback' => 'session#create'", :after => /Application.routes.draw do*/
          inject_into_file route_file, "\n  get '/auth/:provider/callback' => 'session#create'", :after => /Application.routes.draw do*/
          inject_into_file route_file, "\n  get '/auth/:provider' => 'session#create', :as => :login", :after => /Application.routes.draw do*/
          
        end
        
      end
      
    end
  end
end