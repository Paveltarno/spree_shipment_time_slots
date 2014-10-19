module Spree
  Order.class_eval do
    
    belongs_to :shipment_time_slot

  end
end