class CreateSpreeShipmentTimeSlots < ActiveRecord::Migration
  def change
    create_table :spree_shipment_time_slots do |t|
      t.datetime :starting_at
      t.datetime :ending_at
      t.integer :order_limit
      t.references :shipment_time_slot, index: true
      t.timestamps
    end
  end
end
