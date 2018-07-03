class BidsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_and_check_lot

  def create
    @bid = current_user.bids.build(bid_params)
    if @bid.save
      send_response(@bid)
    else
      send_response(@bid.errors, 403)
    end
  end

  private

  # get bid params
  def bid_params
    params.permit(:lot_id, :proposed_price)
  end

  # set current lot
  def set_and_check_lot
    Lot.exists?(params[:lot_id]) ? (@lot = Lot.find(params[:lot_id])) : (raise 'Lot not found')
    if @lot.in_process? == false
      raise 'Forbidden - lot status is not in_process'
    elsif current_user.id == @lot.user_id
      raise 'Lot seller cant create bid'
    end
  end

end
