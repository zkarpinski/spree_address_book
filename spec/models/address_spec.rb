require 'spec_helper'

describe Spree::Address do

  # Test spree_address_book's address_decorator.rb.
  describe 'spree_address_book address_decorator' do
    let(:address) { FactoryGirl.create(:address) }
    let(:address2) { FactoryGirl.create(:address) }
    let(:order) { FactoryGirl.create(:order) }
    let(:user) { FactoryGirl.create(:user) }

    before {
      order.bill_address = address2
      order.state = "complete"
      order.save
    }

    it 'has required attributes' do
      Spree::Address.required_fields.should eq([:firstname, :lastname, :address1, :city, :zipcode, :country, :phone])
    end

    it 'is editable' do
      address.should be_editable
    end

    it 'can be deleted' do
      address.should be_can_be_deleted
    end

    it "isn't editable when there is an associated order" do
      address2.should_not be_editable
    end

    it "can't be deleted when there is an associated order" do
      address2.should_not be_can_be_deleted
    end

    it 'is displayed as string' do
      a = address
      address.to_s.should include(a.firstname, a.lastname, a.address1, a.city, (a.state ? a.state.abbr : a.state_name), a.zipcode, a.country.iso3)
    end

    it 'is destroyed without saving used' do
      address.destroy
      Spree::Address.where(["id = (?)", address.id]).should be_empty
    end

    it 'is destroyed deleted timestamp' do
      address2.destroy
      Spree::Address.where(["id = (?)", address2.id]).should_not be_empty
    end
  end

end
