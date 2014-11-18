require 'spec_helper'

describe Spree::Shipment do
  before { @shipment = FactoryGirl.create(:shipment)}

  subject { @shipment }

  it{ should respond_to(:shipment_time_slot) }
end
