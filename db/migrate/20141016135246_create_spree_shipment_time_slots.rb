class CreateSpreeShipmentTimeSlots < ActiveRecord::Migration
  def change
    create_table :spree_shipment_time_slots do |t|
      t.datetime :starting_at
      t.datetime :ending_at
      t.integer :order_limit

      t.timestamps
    end
  end
end
