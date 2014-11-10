module Spree
  module Admin
    class TimeSlotDayPlansController < ResourceController

      private

        def permitted_resource_params
          processed_params = process_params(params.dup)

          @permitted_resource_params ||= processed_params.
            require('time_slot_day_plan').
            permit(:name, shipment_time_slot_single_plans_attributes: [:starting_hour, :ending_hour, :order_limit, :_destroy])

          return @permitted_resource_params
        end

        def process_params(params)
          params["time_slot_day_plan"]["shipment_time_slot_single_plans_attributes"].each do |record|
            single_plan = record.last
            ["starting_hour", "ending_hour"].each do |k|
              single_plan[k] = transform_to_sec( single_plan["#{k}(4i)"], single_plan["#{k}(5i)"] )
              
              # Remove the junk keys
              (1..5).each { |i| single_plan.except!("#{k}(#{i}i)") }
            end
          end

          return params
        end

        def transform_to_sec(hours, minutes)
          hours.to_i.hours + minutes.to_i.minutes
        end

    end
  end
end