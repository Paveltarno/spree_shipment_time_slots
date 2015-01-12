require 'spec_helper'

describe Spree::TimeSlotPlanner do

  before do
    Spree::ShipmentTimeSlotsConfiguration.handling_buffer = 0
    for i in (6).downto(0)
      Spree::RegularPlan.create!(day: i, time_slot_day_plan: create(:time_slot_day_plan))
    end
  end

  subject{Spree::TimeSlotPlanner}

  it{ should respond_to(:regular_plans) }
  it{ should respond_to(:custom_plans) }

  describe "with regular plans" do

    it "should return all regular plans by asc day order" do
      expect(subject.regular_plans.first.day).to eq 0
      expect(subject.regular_plans.last.day).to eq 6
    end

  end

  describe ".get_day_plans_for_next" do
    it "should create the right range caluclated by the given int" do
      expect(subject).
        to receive(:get_day_plans_for_range).
        with(Time.zone.today..3.days.from_now.to_date)
      subject.get_day_plans_for_next(3)
    end

    it "should create a single day range if no value given" do
      expect(subject).
        to receive(:get_day_plans_for_range).
        with(Time.zone.today..Time.zone.today)
      subject.get_day_plans_for_next
    end
  end

  describe ".get_day_plans_for_range" do
    describe "regular plans only" do
      it "should return a hash for multiple range given" do
        result = subject.get_day_plans_for_range(Time.zone.today..2.days.from_now)
        expect(result.length).to eq 3
        result.each{ |k,v| expect(k.is_a?(Date)).to be_truthy }
        result.each do |k,v| 
          expect(v.is_a?(Spree::TimeSlotDayPlan)).to be_truthy
          expect(v.name.include?("plan")).to be_truthy
        end
      end

      it "should return a hash for single range given" do
        result = subject.get_day_plans_for_range(Time.zone.today..Time.zone.today)
        expect(result.length).to eq 1
        result.each{ |k,v| expect(k.is_a?(Date)).to be_truthy }
        result.each{ |k,v| expect(v.is_a?(Spree::TimeSlotDayPlan)).to be_truthy }
      end
    end

    describe "with default plans" do
      before do
        for i in 1..5
          Spree::CustomPlan.create!(date: i.days.from_now,
            time_slot_day_plan: create(:time_slot_day_plan, name:"custom#{i}"))
        end
      end

      it "should return a hash for multiple range given" do
        result = subject.get_day_plans_for_range(2.days.from_now.to_date..4.days.from_now.to_date)
        expect(result.length).to eq 3
        result.each{ |k,v| expect(k.is_a?(Date)).to be_truthy }
        result.each do |k,v| 
          expect(v.is_a?(Spree::TimeSlotDayPlan)).to be_truthy
          expect(v.name.include?("custom")).to be_truthy
        end
      end

      it "should return a hash for single range given" do
        result = subject.get_day_plans_for_range(2.days.from_now.to_date..2.days.from_now.to_date)
        expect(result.length).to eq 1
        result.each{ |k,v| expect(k.is_a?(Date)).to be_truthy }
        result.each do |k,v| 
          expect(v.is_a?(Spree::TimeSlotDayPlan)).to be_truthy
          expect(v.name.include?("custom")).to be_truthy
        end
      end
    end

    describe "with mixed plans" do
      before do
        Spree::CustomPlan.create!(date: 3.days.from_now,
          time_slot_day_plan: create(:time_slot_day_plan, name:"custom"))
      end

      it "should return a hash for multiple range given" do
        result = subject.get_day_plans_for_range(2.days.from_now.to_date..4.days.from_now.to_date)
        expect(result.length).to eq 3
        result.each{ |k,v| expect(k.is_a?(Date)).to be_truthy }
        result.each do |k,v| 
          expect(v.is_a?(Spree::TimeSlotDayPlan)).to be_truthy
        end
        keys = result.keys
        expect(result[keys[0]].name.include?("plan")).to be_truthy
        expect(result[keys[1]].name.include?("custom")).to be_truthy
      end

    end
  end

  describe ".get_time_slots_for_next" do
    describe "mixed plans" do
      before do
        Spree::CustomPlan.create!(date: 1.day.from_now,
          time_slot_day_plan: create(:time_slot_day_plan, name:"custom"))
      end

      it "should return time slots without filter" do
        result = subject.get_time_slots_for_next(2, { filter_full: false, filter_past: false })
        expect(result.length).to eq 3
        result.each do |i|
          expect(i.class).to eq Spree::ShipmentTimeSlot
        end
      end

      it "should filter full time slots by default" do
        time_slot = create(:shipment_time_slot, order_limit: 1)
        time_slot.shipments << create(:shipment)
        time_slot.save!
        full_plan = Spree::CustomPlan.create!(date: Date.today,
          time_slot_day_plan: create(:time_slot_day_plan, name:"custom2"))

        result = subject.get_time_slots_for_next(2, { filter_past: false })
        expect(result.length).to eq 2
        result.each do |i|
          expect(i.class).to eq Spree::ShipmentTimeSlot
        end
      end

      it "should filter past time slots by default" do
        time_slot = create(:shipment_time_slot, order_limit: 1)
        time_slot.shipments << create(:shipment)
        time_slot.save!
        full_plan = Spree::CustomPlan.create!(date: Date.today + 2.day,
          time_slot_day_plan: create(:time_slot_day_plan, name:"custom2"))

        Timecop.freeze(Date.today.end_of_day - 1.hour) do
          result = subject.get_time_slots_for_next(2, { filter_full: false })
          expect(result.length).to eq 2
          result.each do |i|
            expect(i.class).to eq Spree::ShipmentTimeSlot
          end
        end
      end

      it "should filter past time slots by ending_at" do
        time_slot = create(:shipment_time_slot, order_limit: 1)
        time_slot.shipments << create(:shipment)
        time_slot.save!
        full_plan = Spree::CustomPlan.create!(date: Date.today + 2.day,
          time_slot_day_plan: create(:time_slot_day_plan, name:"custom2"))

        Timecop.freeze(Date.today.beginning_of_day + 6.hour) do
          result = subject.get_time_slots_for_next(2, { filter_full: false })
          expect(result.length).to eq 3
          result.each do |i|
            expect(i.class).to eq Spree::ShipmentTimeSlot
          end
        end
      end

      it "should filter past time slots by starting_at as params" do
        time_slot = create(:shipment_time_slot, order_limit: 1)
        time_slot.shipments << create(:shipment)
        time_slot.save!
        full_plan = Spree::CustomPlan.create!(date: Date.today + 2.day,
          time_slot_day_plan: create(:time_slot_day_plan, name:"custom2"))

        Timecop.freeze(Date.today.beginning_of_day + 6.hour) do
          result = subject.get_time_slots_for_next(2, { filter_full: false, filter_past_by: :starting_at })
          expect(result.length).to eq 2
          result.each do |i|
            expect(i.class).to eq Spree::ShipmentTimeSlot
          end
        end
      end

      it "should filter past times with a handling buffer" do
        time_slot = create(:shipment_time_slot)
        time_slot.shipments << create(:shipment)
        time_slot.save!
        full_plan = Spree::CustomPlan.create!(date: Date.today + 2.day,
          time_slot_day_plan: create(:time_slot_day_plan, name:"custom2"))

        Timecop.freeze(Date.today.beginning_of_day + 6.hour) do
          result = subject.get_time_slots_for_next(2, handling_buffer: 3.hours)
          expect(result.length).to eq 2
          result.each do |i|
            expect(i.class).to eq Spree::ShipmentTimeSlot
          end
        end
      end

    end
  end


end