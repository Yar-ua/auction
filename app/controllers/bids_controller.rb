class BidsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lot

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
        send_response("Lot seller can't create bid", 403)
      end
    else
      send_response("Lot seller can't create bid", 406)
    end
  end


  private

  # get bid params
  def bid_params
    params.permit(:lot_id, :proposed_price)
  end

  # set current lot
  def set_lot
    begin
      @lot = Lot.find(params[:lot_id])
    rescue Exception => e
      send_response('Lot not found', 404)
    end
  end

  # def user_not_lot_owner
  #   return current_user.id != @lot.user_id
  # end

end

  # def create
  #   if current_user.id != @lot.user_id
  #     if @lot.in_process?
  #       @bid = current_user.bids.build(bid_params)
  #       if @bid.save
  #         send_response(@bid)
  #       else
  #         send_response('Bid not created', 400)
  #       end
  #     else
  #       raise 'Forbidden - Lot is not in_process'
  #     end
  #   else
  #     send_response("Lot seller can't create bid", 406)
  #   end
  # end