module Spree

  #
  # Represents a single time slot for shipping orders
  # each slot can hold several orders (up to the order_limit value)
  # and is used for bulk delivery of orders
  class ShipmentTimeSlot < Spree::Base
    has_many :orders, inverse_of: :shipment_time_slot

    validates_numericality_of :order_limit, only_integer: true, greater_then: 0
    validate :orders_cannot_be_greater_then_order_limit

    private

      # Custom validators
      def orders_cannot_be_greater_then_order_limit
        return unless order_limit
        if orders.length > order_limit
          errors.add(:orders, "can't be greater then the order limit: #{order_limit}")
        end
      end
    
  end

end
