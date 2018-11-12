require "rails_helper"

RSpec.describe CustomerMailer, type: :mailer do
  describe 'send_winning_lot_email' do
    before do
      @user = FactoryBot.create(:user)
      @seller = FactoryBot.create(:user)
      @lot = FactoryBot.create(:lot, :in_process, user: @seller)
      @bid = FactoryBot.create(:bid, :winner, user: @user, lot: @lot, proposed_price: @lot.current_price + 1)
      @order = FactoryBot.create(:order, lot: @lot)
      @mail = described_class.order_sent_email(@order).deliver_now
    end

    it 'mail have lot' do
      expect(@mail.subject).to eq(
        "Your lot " + @lot.title + " was sent")
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
