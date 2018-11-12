require "rails_helper"

RSpec.describe SellerMailer, type: :mailer do
  before do
    @user = FactoryBot.create(:user)
    @lot = FactoryBot.create(:lot, user: @user)
    @order = FactoryBot.create(:order, lot: @lot)
  end

  describe 'when the order was created' do
    before do
      @mail = described_class.order_create_email(@order).deliver_now
    end

    it 'mail have order' do
      expect(@mail.subject).to eq("Order was created on Your lot " + @lot.title)
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

  describe 'send_lot_closed_by_timeout_email' do
    before do
      @mail = described_class.order_delivered_email(@order).deliver_now
    end

    it 'mail have order' do
      expect(@mail.subject).to eq("Order on Your lot " + @lot.title + " was successfully delivered")
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
