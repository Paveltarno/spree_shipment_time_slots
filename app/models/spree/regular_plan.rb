class Spree::RegularPlan < ActiveRecord::Base
  belongs_to :time_slot_day_plan

  validate :day_number_should_be_in_a_week
  validates_uniqueness_of :day

  DAY_NUMBERS = (0..6).to_a

  private

    def day_number_should_be_in_a_week
      unless DAY_NUMBERS.include?(self.day)
        errors.add(:day, Spree.t(:should_be_a_week_number))
      end
    end

end
