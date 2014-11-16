module Spree

  class CustomPlanSet

    include ActiveModel::Model

    attr_accessor :date

    def custom_plans
      @custom_plans ||= Spree::CustomPlan.where(date: @date.beginning_of_month..@date.end_of_month).all
    end

    def custom_plans_by_date
      @custom_plans_by_date ||= Hash[ custom_plans.map { |plan| [plan.date, plan] } ]
    end

    def to_param
      @date.strftime
    end

    def update(params)
      params[:custom_plans].keys.each do |custom_plan_date|

        # Check if custom plan exists
        custom_plan = custom_plans_by_date[Date.parse(custom_plan_date)]

        # Create a new one if not
        custom_plan ||= Spree::CustomPlan.new(date: custom_plan_date)

        # Check if any day plan given
        day_plan_id = params[:custom_plans][custom_plan_date][:time_slot_day_plan_id]

        if !day_plan_id.empty?

          # Save or update the custom plan
          custom_plan.time_slot_day_plan_id = day_plan_id
          custom_plan.save!
        elsif !custom_plan.new_record?

          # Delete the custom plan if no day plan given
          custom_plan.destroy!
        end
      end
    end

  end

end
