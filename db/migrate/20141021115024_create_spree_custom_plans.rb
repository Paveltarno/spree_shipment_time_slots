class CreateSpreeCustomPlans < ActiveRecord::Migration
  def change
    create_table :spree_custom_plans do |t|
      t.date :date
      t.integer :time_slot_day_plan_id

      t.timestamps
    end

    add_index :spree_custom_plans, :date, unique: true
  end
end
