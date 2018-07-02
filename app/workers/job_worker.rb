class JobWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"

  def perform(lot_id, status)

    lot = Lot.find(lot_id)
    if lot.exists?
      if status == 'in_process'
        lot.in_process!
      elsif status == 'closed'
        lot.closed!
      end
    else
      raise 'Lot not found, cant create job'
    end

  end
end
