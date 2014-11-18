require 'spec_helper'

describe Spree::ShipmentTimeSlot do
  before { @timeslot = create(:shipment_time_slot) }

  subject { @timeslot }

  it{ should respond_to(:id) }
  it{ should respond_to(:starting_at) }
  it{ should respond_to(:ending_at) }
  it{ should respond_to(:order_limit) }
  it{ should respond_to(:shipments) }
  it{ should respond_to(:orders) }

  context "scopes" do
    context ".not_empty" do
      before do
        @timeslot.order_limit.times do
          order = create(:order)
          shipment = create(:shipment,order: order ,shipment_time_slot: @timeslot)
        end

        @timeslot.reload
        create(:shipment_time_slot)
      end

      it "should return only the ones with orders" do
        expect(Spree::ShipmentTimeSlot.count).to eq 2
        expect(Spree::ShipmentTimeSlot.not_empty.count).to eq 1
      end

    end
  end

  context "validations" do
    before do
      @timeslot.order_limit.times do
        order = create(:order)
        shipment = create(:shipment,order: order ,shipment_time_slot: @timeslot)
      end
      @timeslot.reload
    end

    it "should be valid when order limit equals to orders array" do
      expect(@timeslot).to be_valid
    end

    it "should not be valid when order limit is less then shipments array" do
      create(:shipment, shipment_time_slot: @timeslot)
      expect(@timeslot.reload).not_to be_valid
    end
  end

end
