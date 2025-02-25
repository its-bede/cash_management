# frozen_string_literal: true

module CashManagement
  module Generators
    # Generator for CashManagement configuration
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      desc "Creates a CashManagement configuration initializer for your Rails application"

      def copy_initializer
        template "cash_management.rb", "config/initializers/cash_management.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
