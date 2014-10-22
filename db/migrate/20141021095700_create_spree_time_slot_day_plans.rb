class CreateSpreeTimeSlotDayPlans < ActiveRecord::Migration
  def change
    create_table :spree_time_slot_day_plans do |t|
      t.string :name

      t.timestamps
    end
  end
end
