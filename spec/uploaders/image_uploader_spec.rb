require "rails_helper"

require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  let(:lot) { FactoryBot.create(:lot) }
  let(:uploader) { ImageUploader.new(lot, :image) }

  before do
    ImageUploader.enable_processing = true
    File.open("./spec/fixtures/images/ror.png") { |f| uploader.store!(f) }
  end

  after do
    ImageUploader.enable_processing = false
    uploader.remove!
  end

  context 'the small version' do
    it "scales down a landscape image to fit within 400 by 400 pixels" do
      expect(uploader.small).to be_no_larger_than(400, 400)
    end
  end

  context 'the thumb version' do
    it "scales down a landscape image to be exactly 64 by 64 pixels" do
      expect(uploader.thumb).to be_no_larger_than(64, 64)
    end
  end

  it "makes the image readable only to the owner and not executable" do
    expect(uploader).to have_permissions(0755)
  end

  it "has the correct format" do
    expect(uploader).to be_format('png')
  end
end