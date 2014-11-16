module Spree
  class SpreeShipmentTimeSlotsConfiguration < Preferences::Configuration

    # This preference sets the day range to send to the TimeSlotsPlanner on the frontend
    preference :user_day_limit, :integer, default: 3
  end
end
