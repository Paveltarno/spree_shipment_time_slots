module Spree
  module Admin
    class ShipmentTimeSlotsController < Admin::BaseController
      
      helper Spree::Admin::CalendarHelper

      def index
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
        @shipment_time_slots = Spree::ShipmentTimeSlot.same_month_as(@date).not_empty.order(:starting_at).
          all.group_by{ |time_slot| time_slot.starting_at.beginning_of_day }
        session[:return_to] = request.url
      end

      def show
        @shipment_time_slot = Spree::ShipmentTimeSlot.find_by_id(params[:id])
        @search = @shipment_time_slot.orders.accessible_by(current_ability, :index).ransack(params[:q])
        @orders = @search.result(distinct: false)
      end

      protected

        def model_class
          Spree::ShipmentTimeSlot
        end

    end
  end
end
