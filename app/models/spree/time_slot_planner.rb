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

      get_day_plans_for_range(dates)
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

      day_plans = {}

      # If there are any regular plans (should be from seed but we cant rely on that)
      if regular_plans.count > 0
        # Create a hash will all the dates as keys and all the regular plans
        # as their values
        day_plans = dates.inject({}) do |hash, date|

          day_plan = regular_plans.where(day: date.wday).first.time_slot_day_plan
          hash[date] = day_plan if day_plan
          hash
        end
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

    def self.get_time_slots_for_next(days = 0, options = {})
      day_plans = get_day_plans_for_next(days)
      get_time_slots_from_plans(day_plans, options)
    end

    def self.get_time_slots_for_range(dates, options = {})
      day_plans = get_time_slots_for_range(dates)
      get_time_slots_from_plans(day_plans, options)
    end

    #
    # Creates or gets existing ShipmentTimeSlot objects
    #
    # @param [ShipmentTimeSlotDayPlan] plans Day plans
    # @param [Hash] options Options hash can optionally contain
    # filter_full (default: true) to filter full time slots
    # filter_past (:default: true) to filter past time slots
    # filter_past_by (default: ending_at) to filter past time slots by a specified attribute
    # @return [<type>] <description>
    # 
    def self.get_time_slots_from_plans(plans, options = {})

      # set default options
      options[:filter_full] = true if options[:filter_full].nil?
      options[:filter_past] = true if options[:filter_past].nil?
      options[:filter_past_by] = :ending_at if options[:filter_past_by].nil?

      time_slots = []

      # Iterate over the day plans
      plans.each do |date, day_plan|
        
        # Iterate over each single plan
        day_plan.shipment_time_slot_single_plans.each do |single_plan|

          # Get the time slot object from the single plan
          time_slot = single_plan.get_or_build_time_slot(date)
          
          # Filter full time slots and past
          unless (options[:filter_full] == true && time_slot.full?) ||
              (options[:filter_past] && time_slot.send(options[:filter_past_by]) < Time.zone.now)
            time_slots << time_slot
          end

        end
      end
      
      # Persist time slots
      time_slots.each { |time_slot| time_slot.save! if time_slot.new_record? }

      return time_slots

    end

    private_class_method :get_time_slots_from_plans


  end
end