require "rails_helper"

RSpec.describe CustomerMailer, type: :mailer do
  describe 'send_winning_lot_email' do
    before do
      @user = FactoryBot.create(:user)
      @lot = FactoryBot.create(:lot, :in_process, user: @user)
      @bid = FactoryBot.create(:bid, :winner, user: @user, lot: @lot, proposed_price: @lot.current_price + 1)
      @mail = described_class.send_winning_lot_email(@bid).deliver_now
    end

    it 'mail have lot' do
      expect(@mail.subject).to eq(
        "You are winner in the lot " + @lot.title + " with your bid " + @bid.proposed_price.to_s)
    end

    it 'renders the receiver email' do
      expect(@mail.to).to eq([@user.email])
    end

    it 'renders the sender email' do
      expect(@mail.from).to eq(['auction@marketplace.com'])
    end

    it 'mail have user.first_name' do
      expect(@mail.body.encoded).to match(@user.first_name)
    end

    it 'mail have url to lot' do
      expect(@mail.body.encoded)
        .to match('More information - by link ' + ENV["front_app_url"] + '/lots/' + @lot.id.to_s)
    end

  end

end
