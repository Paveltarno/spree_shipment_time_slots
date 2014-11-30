module Spree

  #
  # Represents a single time slot for shipping orders
  # each slot can hold several orders (up to the order_limit value)
  # and is used for bulk delivery of orders
  class ShipmentTimeSlot < Spree::Base
    include Rails.application.routes.url_helpers

    has_many :shipments, inverse_of: :shipment_time_slot

    # TODO: change order_limit to shipment_limit
    validates_numericality_of :order_limit, only_integer: true, greater_then: 0
    validate :shipments_cannot_be_greater_then_order_limit
    validate :starting_and_ending_should_be_on_same_day

    scope :not_empty, -> { where("shipments_count > ?", 0) }
    scope :same_month_as, -> (date) { where("starting_at >= ? and starting_at <= ?",
     date.beginning_of_month.beginning_of_day, date.end_of_month.end_of_day) }

    def self.orders_for(shipment_time_slot_id = Spree::ShipmentTimeSlot.select(:id).all)
      Spree::Order.
        joins(shipments: :shipment_time_slot).
        where("spree_shipment_time_slots.id IN (?)", shipment_time_slot_id)
    end

    def orders
      @orders ||= Spree::ShipmentTimeSlot.orders_for(self.id)
    end

    def full?
      shipments.length == order_limit
    end

    # TODO: move all the string to a helper
    def user_string
      "#{date_string} #{hours_string}"
    end

    def admin_string(with_date = true)
      "#{with_date ? date_string : ""} #{hours_string} -> #{orders_string}"
    end

    def date_string
      Spree.l starting_at, format: "%A %d/%m/%Y "
    end

    def hours_string
      "#{starting_at.strftime("%H:%M")} - #{ending_at.strftime("%H:%M")}"
    end

    def shipments_string
      "#{shipments.count} #{Spree.t(:shipments)}"
    end

    def orders_string
      # TODO: Add pluralization
      "#{shipments_count ? shipments_count : "0" } #{Spree.t(:shipments)}"
    end

    # This override includes more data then the default one
    # this is done for the Spree API (because RABL templates cannot be "defaced" or decorated,
    # and a custom tmplate brakes the idea of seamless extensions)
    def as_json(*args)
      json = super.as_json(*args)
      json["admin_string"] = admin_string
      return json
    end

    # def orders
    #   shipments.select(:order).distinct.all
    #   #orders = shipments.each { |shipment| shipment.order }
    # end

    private

      # Custom validators
      def shipments_cannot_be_greater_then_order_limit
        return unless order_limit
        if shipments.length > order_limit
          errors.add(:shipmnets, Spree.t(:should_be_smaller_then_order_limit, order_limit: order_limit))
        end
      end

      def starting_and_ending_should_be_on_same_day
        return unless starting_at && ending_at
        if starting_at.beginning_of_day != ending_at.beginning_of_day
          errors.add(:starting_at, Spree.t(:should_be_same_date_as_ending_at))
        end
      end
    
  end

end
