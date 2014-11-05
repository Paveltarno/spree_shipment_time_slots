module Spree
  module Admin
    class ShipmentTimeSlotSinglePlansController < Spree::Admin::BaseController

      def new
        @object = Spree::ShipmentTimeSlotSinglePlan.new
        respond_to do |format|
          format.html { render :layout => !request.xhr?, locals: { object: @object } }
          if request.xhr?
            format.js   { render :layout => false, locals: { object: @object } }
          end
        end
      end

    end
  end
end
