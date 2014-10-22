class Spree::TimeSlotDayPlan < ActiveRecord::Base

  has_many :shipment_time_slot_single_plans, dependent: :destroy
  validates_uniqueness_of :name
  
end
