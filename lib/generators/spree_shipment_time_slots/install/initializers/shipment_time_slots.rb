# Add any initialization for spree_shipment_time_slots extension here
# This file should be modified outside of the extension code because it
# is copied upon extension install and deleted on remove
# -------------------------------------------------------------------

# Init config
Spree::ShipmentTimeSlotsConfiguration = Spree::SpreeShipmentTimeSlotsConfiguration.new

# Add strong params
Spree::PermittedAttributes.shipment_attributes << :shipment_time_slot_id
