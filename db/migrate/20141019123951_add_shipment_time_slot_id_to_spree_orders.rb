class AddShipmentTimeSlotIdToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :shipment_time_slot_id, :integer
  end
end
