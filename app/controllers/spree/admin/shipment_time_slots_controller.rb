module Spree
  module Admin
    class ShipmentTimeSlotsController < ResourceController
      
      helper Spree::Admin::CalendarHelper

      def index
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
      end

    end
  end
end