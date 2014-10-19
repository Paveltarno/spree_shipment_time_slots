require 'spec_helper'

describe Spree::Order do
  before { @order = FactoryGirl.create(:order)}

  subject { @order }

  it{ should respond_to(:shipment_time_slot) }
end