class Spree::RegularPlan < ActiveRecord::Base
  belongs_to :time_slot_day_plan

  validate :day_number_should_be_in_a_week
  validates_uniqueness_of :day

  DAY_NUMBERS = (0..6).to_a

  private

    def day_number_should_be_in_a_week
      unless DAY_NUMBERS.include?(self.day)
        errors.add(:day, "should be a number between 0 to 6 representing a day of the week")
      end
    end

end
