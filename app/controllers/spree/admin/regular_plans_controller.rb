module Spree
  module Admin
    class RegularPlansController < Admin::BaseController
      # TODO: This controller is not RESTful a WeeklyPlan facade object should be created
      # to manipulated the data for bulk updates

      helper Spree::Admin::CalendarHelper

      before_action :fill_regular_plans_hash

      def update
        errors = []
        @regular_plans.values.each do |plan|
          plan.time_slot_day_plan_id = regular_plans_params[plan.id.to_s][:time_slot_day_plan_id]
          errors << plan unless plan.save
        end
        if errors.empty?
          flash[:success] = Spree.t(:weekly_plan_successfully_updated)
          redirect_to admin_regular_plans_url
        else
          flash.now[:error] =
           errors.map{ |obj| "#{obj.id} - #{obj.errors.full_messages.join(",")}" }.join("|")
          render action: :index
        end

      end

      protected

        def model_class
          Spree::RegularPlan
        end

      private

        def regular_plans_params
          @regular_plans_params ||= params.require('regular_plans')
        end

        def fill_regular_plans_hash
          plans = Spree::RegularPlan.order(:day)
          @regular_plans = {}
          plans.each { |plan| @regular_plans[plan.day] = plan }
        end

    end
  end
end
