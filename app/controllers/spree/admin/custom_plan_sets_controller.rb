module Spree
  module Admin
    class CustomPlanSetsController < Spree::Admin::BaseController

      helper Spree::Admin::CalendarHelper
      
      def edit
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
        @plan_set = Spree::CustomPlanSet.new(date: @date)
      end

      def update
        @date = Date.parse(custom_plan_set_params[:date])
        Spree::CustomPlanSet.new(date: @date).update(custom_plan_set_params)
        flash[:success] = Spree.t(:custom_plan_set_successfully_updated)
        redirect_to admin_custom_plans_url
      end

      protected

        def model_class
          Spree::CustomPlanSet
        end

      private

        def custom_plan_set_params
          @custom_plan_set_params ||= params.require(:custom_plan_set)
        end

    end
  end
end
