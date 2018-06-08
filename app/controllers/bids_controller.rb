class BidsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lot

  # def index
  #   send_response('')
  # end

  ####
  #### TODO implement checks of bid value, must be more than last bid and more than 
  #### current price
  #### add changing current_price by bid

  # after creation update current_price

  # after creation check estimated prise and set winner if need

  def create
    if current_user.id != @lot.user_id
      if @lot.in_process?
        @bid = current_user.bids.build(bid_params)
        if @bid.save
          send_response(@bid)
        else
          send_response('Bid not created', 400)
        end
      else
        send_response('Forbidden - Lot is not in_process', 403)
      end
    else
      send_response("Lot seller can't create bid", 406)
    end
  end


  private

  def bid_params
    params.permit(:lot_id, :proposed_price)
  end

  def set_lot
    # @lot = Lot.find(params[:lot_id])
    if Lot.exists?(params[:lot_id])
      @lot = Lot.find(params[:lot_id])
    else
      send_response('Lot not found', 404)
    end
  end

end
