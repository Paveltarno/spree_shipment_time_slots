require 'spec_helper'

describe Spree::TimeSlotPlanner do

  before do
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
        result.each{ |k,v| expect(k.is_a?(Date)).to be_true }
        result.each do |k,v| 
          expect(v.is_a?(Spree::TimeSlotDayPlan)).to be_true
          expect(v.name.include?("plan")).to be_true
        end
      end

      it "should return a hash for single range given" do
        result = subject.get_day_plans_for_range(Time.zone.today..Time.zone.today)
        expect(result.length).to eq 1
        result.each{ |k,v| expect(k.is_a?(Date)).to be_true }
        result.each{ |k,v| expect(v.is_a?(Spree::TimeSlotDayPlan)).to be_true }
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
        result.each{ |k,v| expect(k.is_a?(Date)).to be_true }
        result.each do |k,v| 
          expect(v.is_a?(Spree::TimeSlotDayPlan)).to be_true
          expect(v.name.include?("custom")).to be_true
        end
      end

      it "should return a hash for single range given" do
        result = subject.get_day_plans_for_range(2.days.from_now.to_date..2.days.from_now.to_date)
        expect(result.length).to eq 1
        result.each{ |k,v| expect(k.is_a?(Date)).to be_true }
        result.each do |k,v| 
          expect(v.is_a?(Spree::TimeSlotDayPlan)).to be_true
          expect(v.name.include?("custom")).to be_true
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
        result.each{ |k,v| expect(k.is_a?(Date)).to be_true }
        result.each do |k,v| 
          expect(v.is_a?(Spree::TimeSlotDayPlan)).to be_true
        end
        keys = result.keys
        expect(result[keys[0]].name.include?("plan")).to be_true
        expect(result[keys[1]].name.include?("custom")).to be_true
      end

    end
  end


end