class Spree::TimeSlotDayPlan < ActiveRecord::Base

  has_many :shipment_time_slot_single_plans, dependent: :destroy
  validates_presence_of :shipment_time_slot_single_plans
  validates_presence_of :name
  validates_uniqueness_of :name
  accepts_nested_attributes_for :shipment_time_slot_single_plans, allow_destroy: true
  
end
