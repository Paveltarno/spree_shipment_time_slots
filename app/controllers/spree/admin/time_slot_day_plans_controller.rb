module Spree
  module Admin
    class TimeSlotDayPlansController < ResourceController

      private

        def permitted_resource_params
          @permitted_resource_params ||= params.
            require('time_slot_day_plan').
            permit(:id, :name, shipment_time_slot_single_plans_attributes: [:id, :starting_hour, :ending_hour, :order_limit, :_destroy])

          return @permitted_resource_params
        end

    end
  end
end