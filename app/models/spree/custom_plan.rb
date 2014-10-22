class Spree::CustomPlan < ActiveRecord::Base
  belongs_to :time_slot_day_plan
  
  validates_uniqueness_of :date

end
