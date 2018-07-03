class LotStatusJob < ApplicationJob
  queue_as :default

  def perform(lot_id, status)
    lot = Lot.find(lot_id)
    if status == 'in_process'
      lot.in_process!
    elsif status == 'closed'
      lot.closed!
    end
  end

end
