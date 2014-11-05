module Spree
  module Admin
    class TimeSlotDayPlansController < ResourceController

      def create
        binding.pry
        super.create
      end

      private

        def permitted_resource_params
          @permitted_resource_params ||= params.
            require('time_slot_day_plan').
            permit(shipment_time_slot_single_plan_attributes: [:starting_hour, :ending_hour, :order_limit])
        end

    end
  end
end