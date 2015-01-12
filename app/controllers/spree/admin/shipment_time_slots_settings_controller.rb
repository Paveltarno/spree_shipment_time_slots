module Spree
  module Admin
    class ShipmentTimeSlotsSettingsController < Spree::Admin::BaseController

      def edit
        @settings = [:user_day_limit, :admin_day_limit, :handling_buffer]
      end

      def update
        params.each do |name, value|
          next unless Spree::ShipmentTimeSlotsConfiguration.has_preference? name
          Spree::ShipmentTimeSlotsConfiguration[name] = value
        end

        flash[:success] = Spree.t(:successfully_updated, :resource => Spree.t(:shipment_time_slots_settings))
        redirect_to edit_admin_shipment_time_slots_settings_url
      end

    end
  end
end