require 'spec_helper'

describe Spree::ShipmentTimeSlotSinglePlan do
  before { @plan = create(:shipment_time_slot_single_plan) }

  subject { @plan }

  it{ should respond_to(:id) }
  it{ should respond_to(:starting_hour) }
  it{ should respond_to(:ending_hour) }
  it{ should respond_to(:order_limit) }
  it{ should respond_to(:time_slot_day_plan) }

  describe "Validations" do

    it "should be valid" do
      expect(@plan).to be_valid
    end

    it "should not be valid without starting hour" do
      @plan.starting_hour = nil
      expect(@plan).not_to be_valid
    end

    it "should not be valid without ending hour" do
      @plan.ending_hour = nil
      expect(@plan).not_to be_valid
    end

    it "should not be valid with a negative order limit" do
      @plan.order_limit = -3
      expect(@plan).not_to be_valid
    end

    it "should not be valid with a non numeric order limit" do
      @plan.order_limit = "a"
      expect(@plan).not_to be_valid
    end

    it "should not be valid with a starting_hour greater then the ending_hour" do
      @plan.starting_hour = 2.hour
      @plan.ending_hour = 1.hour
      expect(@plan).not_to be_valid
    end

    it "should not be valid with a starting_hour equal to the ending_hour" do
      @plan.starting_hour = @plan.ending_hour = 1.hour
      expect(@plan).not_to be_valid
    end
  end

  describe ".build_time_slot" do

      it "should build a valid time slot" do
        result = subject.build_time_slot(Time.zone.now.to_date)
        expected_start_time = Time.zone.now.beginning_of_day + subject.starting_hour.hour
        expected_end_time = Time.zone.now.beginning_of_day + subject.ending_hour.hour
        expect(result.starting_at).to eq expected_start_time
        expect(result.ending_at).to eq expected_end_time
        expect(result.order_limit).to eq subject.order_limit
      end

      describe "invalid build" do

        it "should be invalid if no Time object was given" do
          expect{ subject.build_time_slot }.to raise_error(ArgumentError)
        end

      end

  end
end
