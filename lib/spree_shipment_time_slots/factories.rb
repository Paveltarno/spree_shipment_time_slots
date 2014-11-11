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

  factory :shipment_time_slot_single_plan, class: Spree::ShipmentTimeSlotSinglePlan do
    starting_hour Time.zone.now.beginning_of_day
    ending_hour Time.zone.now.beginning_of_day + 7.hours
    order_limit 2
    time_slot_day_plan nil
  end

  factory :time_slot_day_plan, class: Spree::TimeSlotDayPlan do
    sequence(:name)  { |n| "plan#{n}" }

    before(:create) do |day_plan, values|
      day_plan.shipment_time_slot_single_plans << create_list(:shipment_time_slot_single_plan,
       1,
      time_slot_day_plan: day_plan)
    end
  end

end
