require 'spec_helper'

describe Spree::RegularPlan do
  describe "validations" do

    it "should only accept day of week" do
      plan = Spree::RegularPlan.new(day: 1)
      expect(plan).to be_valid
    end

    it "should not accept non week numbers" do
      plan = Spree::RegularPlan.new(day: 10)
      expect(plan).not_to be_valid
    end

    it "should enforce uniquness of day" do
      plan = Spree::RegularPlan.create!(day: 1)
      plan2 = Spree::RegularPlan.new(day: 1)
      expect(plan2).not_to be_valid
    end

  end
end
