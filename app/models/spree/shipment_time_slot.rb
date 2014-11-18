module Spree

  #
  # Represents a single time slot for shipping orders
  # each slot can hold several orders (up to the order_limit value)
  # and is used for bulk delivery of orders
  class ShipmentTimeSlot < Spree::Base
    has_many :shipments, inverse_of: :shipment_time_slot

    validates_numericality_of :order_limit, only_integer: true, greater_then: 0
    validate :orders_cannot_be_greater_then_order_limit

    scope :not_empty, -> { where("shipments_count > ?", 0) }

    def full?
      shipments.length == order_limit
    end

    def user_string
      Spree.l starting_at, format: "%A %m/%d/%Y" + 
        " #{starting_at.strftime("%H:%M")} - #{ending_at.strftime("%H:%M")}"
    end

    def orders
      shipments.collect { |shipment| shipment.order }
    end

    private

      # Custom validators
      def orders_cannot_be_greater_then_order_limit
        return unless order_limit
        if shipments.length > order_limit
          errors.add(:orders, Spree.t(:should_be_smaller_then_order_limit, order_limit: order_limit))
        end
      end
    
  end

end
