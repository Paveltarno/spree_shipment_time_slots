module Spree
  module Admin
    class CustomPlanSetsController < Spree::Admin::BaseController

      helper Spree::Admin::CalendarHelper
      
      def edit
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
      end

      protected

        def model_class
          Spree::CustomPlanSet
        end

    end
  end
end