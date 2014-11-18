class AddShipmentTimeSlotIdToSpreeShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :shipment_time_slot_id, :integer
  end
end
