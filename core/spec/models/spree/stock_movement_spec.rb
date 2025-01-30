# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spree::StockMovement, type: :model do
  let(:stock_location) { create(:stock_location_with_items) }
  let(:stock_item) { stock_location.stock_items.order(:id).first }
  subject { build(:stock_movement, stock_item:) }

  it 'should belong to a stock item' do
    expect(subject).to respond_to(:stock_item)
  end

  it 'should have a variant' do
    expect(subject).to respond_to(:variant)
  end

  it 'is readonly unless new' do
    subject.save
    expect {
      subject.save
    }.to raise_error(ActiveRecord::ReadOnlyRecord)
  end

  it 'does not update count on hand when track inventory levels is false' do
    stub_spree_preferences(track_inventory_levels: false)
    subject.quantity = 1
    subject.save
    stock_item.reload
    expect(stock_item.count_on_hand).to eq(10)
  end

  it 'does not update count on hand when variant inventory tracking is off' do
    stock_item.variant.track_inventory = false
    subject.quantity = 1
    subject.save
    stock_item.reload
    expect(stock_item.count_on_hand).to eq(10)
  end

  context "when quantity is negative" do
    context "after save" do
      it "should decrement the stock item count on hand" do
        subject.quantity = -1
        subject.save
        stock_item.reload
        expect(stock_item.count_on_hand).to eq(9)
      end
    end
  end

  context "when quantity is positive" do
    context "after save" do
      it "should increment the stock item count on hand" do
        subject.quantity = 1
        subject.save
        stock_item.reload
        expect(stock_item.count_on_hand).to eq(11)
      end
    end
  end

  describe "metadata fields" do
    it "responds to customer_metadata" do
      expect(subject).to respond_to(:customer_metadata)
    end

    it "responds to admin_metadata" do
      expect(subject).to respond_to(:admin_metadata)
    end

    it "can store data in customer_metadata" do
      subject.customer_metadata = { "movement_reason" => "restock" }
      expect(subject.customer_metadata["movement_reason"]).to eq("restock")
    end

    it "can store data in admin_metadata" do
      subject.admin_metadata = { "internal_note" => "Inventory verified" }
      expect(subject.admin_metadata["internal_note"]).to eq("Inventory verified")
    end
  end
end
