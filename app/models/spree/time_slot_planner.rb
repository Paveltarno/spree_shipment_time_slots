module Spree

  #
  # Class TimeSlotPlanner provides orchestration for
  # planning and creating shipment time slots
  #
  class TimeSlotPlanner

    def self.regular_plans
      Spree::RegularPlan.order(:day)
    end

    def self.custom_plans
      Spree::CustomPlan.order(:date)
    end

    #
    # Returns a hash of dates and day plans for the requested next days
    # 
    # @param [int] days Number of days from today to include in the search
    #
    # @return [Hash<Date,Spree::TimeSlotDayPlan>]
    # 
    def self.get_day_plans_for_next(days = 0)
      # Create date range
      dates = Time.zone.today..days.days.from_now.to_date

      self.get_day_plans_for_range(dates)
    end

    #
    # Returns a hash of dates and day plans for the requested date range
    #
    # @param [Range<Date>] dates A range of Date objects
    #
    # @return [Hash<Date,Spree::TimeSlotDayPlan>]
    #
    def self.get_day_plans_for_range(dates)
      # Check params
      dates = dates.to_a

      # Create a hash will all the dates as keys and all the regular plans
      # as their values
      day_plans = dates.inject({}) do |hash, date|
        hash[date] = regular_plans.where(day: date.wday).first.time_slot_day_plan
        hash
      end

      # Fetch the needed custom plans
      filter_custom_plans = custom_plans.where(date: dates)

      # If something returned
      unless filter_custom_plans.empty?

        # Add custom plans
        day_plans.keys.each do |day|
          custom_plan = filter_custom_plans.where(date:[day]).first

          # If there is a custom plan for this date, put it in the return hash
          day_plans[day] = custom_plan.time_slot_day_plan if custom_plan
        end
      end

      return day_plans

    end

  end
end