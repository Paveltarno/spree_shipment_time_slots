require 'spec_helper'

describe Spree::ShipmentTimeSlot do
  before { @timeslot = create(:shipment_time_slot) }

  subject { @timeslot }

  it{ should respond_to(:id) }
  it{ should respond_to(:starting_at) }
  it{ should respond_to(:ending_at) }
  it{ should respond_to(:order_limit) }
  it{ should respond_to(:shipments) }

  context "scopes" do
    context ".not_empty" do
      before do
        @timeslot.order_limit.times do
          order = create(:order)
          shipment = create(:shipment,order: order ,shipment_time_slot: @timeslot)
        end

        @timeslot.reload
        create(:shipment_time_slot,starting_at: 1.year.from_now, ending_at: 1.year.from_now + 2.hours)

      end

      it "should return only the ones with orders" do
        expect(Spree::ShipmentTimeSlot.count).to eq 2
        expect(Spree::ShipmentTimeSlot.same_month_as(Date.today).count).to eq 1
      end
    end

    context ".same_month_as" do
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

    context ".orders_for" do
      before do
        @timeslot.order_limit.times do
          order = create(:order)
          shipment = create(:shipment, order: order ,shipment_time_slot: @timeslot)
        end

        @timeslot.reload
        time_slot = create(:shipment_time_slot)
        order = create(:order)
        shipment = create(:shipment, order: order ,shipment_time_slot: time_slot)
      end

      it "should return all the orders when no arg passed" do
        expect(Spree::ShipmentTimeSlot.orders_for.count).to eq Spree::Order.all.count
      end

      it "should return only specific orders when arg passed" do
        expect(Spree::ShipmentTimeSlot.orders_for(@timeslot.id).count).to eq @timeslot.order_limit
      end

    end

    context ".orders" do
      before do
        @timeslot.order_limit.times do
          order = create(:order)
          shipment = create(:shipment, order: order ,shipment_time_slot: @timeslot)
        end

        @timeslot.reload
      end

      it "should return all orders associated" do
        expect(@timeslot.orders.count).to eq @timeslot.order_limit
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

    context ".orders_cannot_be_greater_then_order_limit" do

      it "should be valid when order limit equals to orders array" do
        expect(@timeslot).to be_valid
      end

      it "should not be valid when order limit is less then shipments array" do
        create(:shipment, shipment_time_slot: @timeslot)
        expect(@timeslot.reload).not_to be_valid
      end

    end

    context ".starting_and_ending_should_be_on_same_day" do

      it "should be valid when start and end on the same day" do
        @timeslot.ending_at = @timeslot.starting_at + 4.hours
        expect(@timeslot).to be_valid
      end

      it "should not be valid when start and end are not on the same day" do
        @timeslot.ending_at = @timeslot.starting_at + 1.day + 4.hours
        expect(@timeslot).not_to be_valid
      end

      it "should not be valid when start and end are not on the same year" do
        @timeslot.ending_at = @timeslot.starting_at + 1.year + 4.hours
        expect(@timeslot).not_to be_valid
      end

    end

  end

end
