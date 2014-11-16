module SpreeShipmentTimeSlots
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_shipment_time_slots'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "spree.spree_shipment_time_slots.preferences", :after => "spree.environment" do |app|
      Spree::ShipmentTimeSlotsConfiguration = Spree::SpreeShipmentTimeSlotsConfiguration.new
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
