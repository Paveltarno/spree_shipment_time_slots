module Spree
  module Api
    ApiHelpers.module_eval do
      shipment_attributes.push(:shipment_time_slot)
    end
  end
end
