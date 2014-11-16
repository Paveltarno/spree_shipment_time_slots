require 'spec_helper'

describe Spree::TimeSlotDayPlan do
  
  before { @day_plan = create(:time_slot_day_plan) }

  subject{@day_plan}

  it{ should respond_to(:id) }
  it{ should respond_to(:name) }
  it{ should respond_to(:shipment_time_slot_single_plans) }

  describe "associations" do
    it "should destroy associated single plans" do
      single_plan = create(:shipment_time_slot_single_plan)
      @day_plan.shipment_time_slot_single_plans << single_plan
      @day_plan.save!
      expect(@day_plan.reload.shipment_time_slot_single_plans.count).to eq 2
      @day_plan.destroy!
      expect(Spree::ShipmentTimeSlotSinglePlan.count).to eq 0
    end

    describe "nested attributes" do
      let(:params) do
        { time_slot_day_plan: {
          name: 'test', shipment_time_slot_single_plans_attributes: [
            { starting_hour: Date.today + 1.hour, ending_hour: Date.today + 3.hours, order_limit: 10 },
            { starting_hour: Date.today + 4.hour, ending_hour: Date.today + 6.hours, order_limit: 10 },
            { starting_hour: Date.today + 7.hour, ending_hour: Date.today + 9.hours, order_limit: 10 },
          ]
        }}
      end

      let(:invalid_params) do
        { time_slot_day_plan: {
          name: 'test', shipment_time_slot_single_plans_attributes: [
            { starting_hour: Date.today + 1.hour, ending_hour: Date.today + 3.hours, order_limit: 10 },
            { starting_hour: Date.today + 4.hour, ending_hour: Date.today + 6.hours, order_limit: 10 },
            { starting_hour: Date.today + 7.hour, ending_hour: Date.today + 2.hours, order_limit: 10 },
          ]
        }}
      end

      it "should create single plans" do
        day_plan = Spree::TimeSlotDayPlan.create!(params[:time_slot_day_plan])
        expect(day_plan.new_record?).to be_falsey
        expect(day_plan.shipment_time_slot_single_plans.count).to eq 3
      end

      it "should fail if one of the plans is invalid" do
        day_plan = Spree::TimeSlotDayPlan.create(invalid_params[:time_slot_day_plan])
        expect(day_plan.new_record?).to be_truthy
        expect(day_plan.shipment_time_slot_single_plans.count).to eq 0
      end

      describe "allow nested destroy" do
        before do
          @single_plan = @day_plan.shipment_time_slot_single_plans.create!(starting_hour: Date.today + 6.hours,
            ending_hour: Date.today + 8.hours,
            order_limit: 20)
        end

        it "should destroy one of the nested attributes" do
          params = @day_plan.attributes
          params[:shipment_time_slot_single_plans_attributes] = [@single_plan.attributes]
          params[:shipment_time_slot_single_plans_attributes][0][:_destroy] = '1'
          @day_plan.update!(params)
          expect(@single_plan).to be_destroyed
          expect(@day_plan.shipment_time_slot_single_plans.count).to eq 1
        end

        it "should not be valid if all the nested attributes are destroyed" do
          params = @day_plan.attributes
          params[:shipment_time_slot_single_plans_attributes] = []
          @day_plan.shipment_time_slot_single_plans.each_with_index do |single_plan, i|
            params[:shipment_time_slot_single_plans_attributes] << single_plan.attributes
            params[:shipment_time_slot_single_plans_attributes][i][:_destroy] = '1'
          end
          
          @day_plan.update(params)
          expect(@day_plan).not_to be_valid
        end
      end

    end
  end

  describe "validations" do
    it "should validate uniqe names" do
      clone = @day_plan.dup
      expect(clone).not_to be_valid
    end
  end

end
