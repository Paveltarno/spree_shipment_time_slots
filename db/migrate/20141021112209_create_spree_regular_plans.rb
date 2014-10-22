class CreateSpreeRegularPlans < ActiveRecord::Migration
  def change
    create_table :spree_regular_plans do |t|
      t.integer :day
      t.integer :time_slot_day_plan_id

      t.timestamps
    end

    add_index :spree_regular_plans, :day, unique: true
  end
end
