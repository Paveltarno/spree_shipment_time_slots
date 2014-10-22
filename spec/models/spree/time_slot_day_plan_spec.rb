require 'spec_helper'

describe Spree::TimeSlotDayPlan do
  
  before { @day_plan = create(:time_slot_day_plan) }

  subject{@day_plan}

  it{ should respond_to(:id) }
  it{ should respond_to(:name) }
  it{ should respond_to(:shipment_time_slot_single_plans) }

  describe "dependencies" do
    it "should destroy associated single plans" do
      single_plan = create(:shipment_time_slot_single_plan)
      @day_plan.shipment_time_slot_single_plans << single_plan
      @day_plan.save!
      expect(@day_plan.reload.shipment_time_slot_single_plans.count).to eq 1
      @day_plan.destroy!
      expect(Spree::ShipmentTimeSlotSinglePlan.count).to eq 0
    end
  end

  describe "validations" do
    it "should validate uniqe names" do
      clone = @day_plan.dup
      expect(clone).not_to be_valid
    end
  end


end
