module Spree
  Shipment.class_eval do
    
    belongs_to :shipment_time_slot, counter_cache: true

  end
end
