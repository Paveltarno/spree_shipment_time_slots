class AddShipmentsCountToSpreeShipmentTimeSlots < ActiveRecord::Migration
  def change
    add_column :spree_shipment_time_slots, :shipments_count, :integer
  end
end
