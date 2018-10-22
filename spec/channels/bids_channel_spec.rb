# frozen_string_literal: true

require "rails_helper"

RSpec.describe BidsChannel, type: :channel do

  before do
    # initialize connection with identifiers
    @user = FactoryBot.create(:user)
    stub_connection user_id: @user.id
  end

  it "rejects when no room id" do
    subscribe
    expect(subscription).to be_rejected
  end

  it "subscribes to a stream when room id is provided" do
    subscribe(lot_id: 100)
    expect(subscription).to be_confirmed
    expect(streams).to include("bids_for_lot_100_channel")
  end

end
