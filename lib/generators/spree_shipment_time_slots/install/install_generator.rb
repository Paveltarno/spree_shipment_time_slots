module SpreeShipmentTimeSlots
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, :type => :boolean, :default => false
      source_root File.expand_path("../initializers", __FILE__)

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/spree_shipment_time_slots\n"
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/spree_shipment_time_slots\n"
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/spree_shipment_time_slots\n", :before => /\*\//, :verbose => true
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/spree_shipment_time_slots\n", :before => /\*\//, :verbose => true
      end

      def add_initializers
        copy_file 'shipment_time_slots.rb', 'config/initializers/shipment_time_slots.rb'
      end

      def add_seed
        append_file 'db/seeds.rb', "SpreeShipmentTimeSlots::Engine.load_seed if defined?(SpreeShipmentTimeSlots)\n"
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_shipment_time_slots'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
