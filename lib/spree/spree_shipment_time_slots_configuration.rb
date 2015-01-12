module Spree
  class SpreeShipmentTimeSlotsConfiguration < Preferences::Configuration

    # This preference sets the day range to send to the TimeSlotsPlanner on the frontend
    # (i.e 1 equals today and tomorrow)
    preference :user_day_limit, :integer, default: 7
    preference :admin_day_limit, :integer, default: 7

    # The handling buffer represents the time it takes for the store to pack and send the order
    preference :handling_buffer, :integer, default: 0
  end
end
