FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_shipment_time_slots/factories'

  factory :shipment_time_slot, class: Spree::ShipmentTimeSlot do
    starting_at Time.zone.now
    ending_at 7.hours.from_now
    order_limit 2
  end

  factory :aa, class: Spree::ShipmentTimeSlotSinglePlan do
    starting_hour 2.hours
    ending_hour 6.hours
    order_limit 2
  end

end
