require 'rails/generators'

module ActiveAdmin
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Active Admin install generator"
      argument :name, type: :string, default: 'AdminUser'
      hook_for :users, default: 'devise', desc: 'Admin user generator to run. Skip with --skip-users'

      def copy_initializer
        @underscored_user_name = name.underscore
        template 'active_admin.rb.erb', 'config/initializers/active_admin.rb'
      end

      def setup_directory
        empty_directory "app/admin"
        template 'dashboard.rb', 'app/admin/dashboard.rb'
        if options[:users]
          @user_class = name
          template 'admin_user.rb.erb', "app/admin/#{name.underscore}.rb"
        end
      end

      def setup_routes
        route "ActiveAdmin.routes(self)"
      end

      def create_assets
        generate "active_admin:assets"
      end

      def create_migrations
        migration_template 'migrations/create_active_admin_comments.rb', 'db/migrate/create_active_admin_comments.rb'
      end
    end
  end
end
