require 'rails_helper'

RSpec.describe Order, type: :model do

  let(:user) {FactoryBot.create(:user)}
  let(:lot) {FactoryBot.create(:lot, :in_process, user: @user)}
  let(:bid) {FactoryBot.create(:bid, user: @user, lot: @lot, proposed_price: @lot.estimated_price + 1)}
  let(:order) {FactoryBot.create(:order, lot: @lot)}

  describe 'order must have important attributes' do
    it { expect(:id).to be}
    it { expect(:id).to be}
    it { expect(:arrival_location).to be}
    it { expect(:arrival_status).to be}
    it { expect(:arrival_type).to be}
  end

end
