class CreateSpreeShipmentTimeSlotSinglePlans < ActiveRecord::Migration
  def change
    create_table :spree_shipment_time_slot_single_plans do |t|
      t.datetime :starting_hour
      t.datetime :ending_hour
      t.string :order_limit
      t.integer :time_slot_day_plan_id
      t.timestamps
    end
  end
end
