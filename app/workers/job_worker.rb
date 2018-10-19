class JobWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"

  def perform(lot_id, status)
    lot = Lot.find(lot_id)
    if status == 'in_process' and lot.jid_in_process == jid and lot.pending?
      lot.in_process!
    elsif status == 'closed' and lot.jid_closed == jid and lot.in_process?
      lot.closed!
    end
  end
end
