require 'rails_helper'
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe Lot, type: :model do

  let(:user) {FactoryBot.create(:user)}

  let(:lot) {FactoryBot.create(:lot, :user_id => user.id)}

  it 'user after Factory valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'lot after Factory valid with valid attributes' do
    expect(lot).to be_valid
  end

  subject { lot }

  describe 'lot must have all important attributes' do
    it { expect(:title).to be}
    it { expect(:description).to be}
    it { expect(:current_price).to be}
    it { expect(:estimated_price).to be}
    it { expect(:lot_start_time).to be}
    it { expect(:lot_end_time).to be}
    it { expect(:user_id).to be}
  end

  it 'Lot is valid with valid attributes' do
    expect(lot).to be_valid
  end

  describe 'Lots price:' do

    it 'lot current_price cant be less 0' do
      lot.estimated_price = -5
      expect(lot).to be_invalid
    end

    it 'lot estimated_price cant be less 0' do
      lot.current_price = -0.1
      expect(lot).to be_invalid
    end
  end

  describe 'Lot is' do
    it 'invalid if lot_start_time is after lot_end_time' do
      lot.lot_start_time = DateTime.now
      lot.lot_end_time = DateTime.now - 1.second
      expect(lot).to be_invalid
    end

    it 'valid if lot_start_time is before lot_end_time' do
      lot.lot_start_time = DateTime.now
      lot.lot_end_time = DateTime.now + 1.second
      expect(lot).to be_valid
    end

    it 'Lot is invalid without :user_id' do
      lot_attrs = attributes_for(:lot).except(:user_id)
      new_lot = Lot.new lot_attrs
      expect(new_lot).to be_invalid
    end
  end

  it 'if lot closed - it cant be changed' do
    lot.closed!
  end

  describe 'Testing lot workers' do
    describe 'must be created after creation lot' do
      it { expect(:jid_in_process).not_to eq('null')}
      it { expect(:jid_closed).not_to eq(nil)}
    end

    it 'if lot update - workeers update too' do
      @lot = FactoryBot.create(:lot, :user_id => user.id)
      jid_in_process = @lot.jid_in_process
      jid_closed = @lot.jid_closed
      @lot.update_attribute(:lot_start_time, @lot.lot_start_time - 1.second)
      expect(@lot.jid_in_process).not_to eq(jid_in_process)
      @lot.update_attribute(:lot_end_time, @lot.lot_end_time + 1.second)
      expect(@lot.jid_closed).not_to eq(jid_closed)
    end

    it 'creation lot create workers' do
      expect{FactoryBot.create(:lot, :user_id => user.id)}.to change(JobWorker.jobs, :size).by(2)
    end

  end

end
