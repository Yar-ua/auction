require 'rails_helper'
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe JobWorker, type: :worker do
  before do
    @user = FactoryBot.create(:user)
    @lot = FactoryBot.create(:lot, user_id: @user.id)
  end

  it { is_expected.to be_processed_in :high }
  it { should be_retryable true }

  describe 'job for changing lots status:' do
    # before do
    #   JobWorker.perform_at(DateTime.now + 3.minutes, @lot.id, :in_process)
    # end

    it 'any job can be created' do
      expect {JobWorker.perform_at(DateTime.now + 3.minutes, @lot.id, :in_process)}.to change(JobWorker.jobs, :size).by(1)
    end

    it 'job planned with correct date and time' do
      @time = DateTime.now + 10.minutes
      JobWorker.perform_at @time, @lot.id, :in_process
      expect(JobWorker).to have_enqueued_sidekiq_job(@lot.id, 'in_process').at(@time)
    end

  end



end
