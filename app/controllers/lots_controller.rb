class LotsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_lot, only: [:show, :update, :destroy]

  WillPaginate.per_page = 10

  def index
      @lots = Lot.in_process.paginate(:page => params[:page])
      send_response(@lots)
  end

  def mylots
    @my_lots = Lot.sort_lots(params[:sort_type]).paginate(:page => params[:page])
    if @my_lots.empty?
      send_response("You haven't your lots yet", 204)
    else
      send_response(@my_lots)
    end
  end

  def create
    @lot = current_user.lots.build(lot_params)
    if @lot.save
      send_response(@lot)
    else
      send_response(@lot.errors, 422)
    end
  end

  def show
    if @lot.in_process?
      @lot.bids.exists? ? send_response(lot: @lot, bids: @lot.bids) : send_response(@lot)
    else
      send_response('Lot not found or status is not in_process', 404)
    end
  end

  def update
    if (@lot.user_id == current_user.id) and (@lot.pending? == true)
      if @lot.valid?
        @lot.update(lot_params)
        send_response(@lot)
      else
        send_response(@lot.errors, 403)
      end
    else
      send_response('Forbidden - You are not lot creator, or lot status forbid update (not pending)', 422)
    end
  end

  def destroy
    if (@lot.user_id == current_user.id) and (@lot.pending?)
      @lot.destroy
      send_response('Lot deleted successfully')
    else
      send_response('Deleting impossible, you are not owner or lot status is not pending', 422)
    end
  end


  private

  # get lots params
  def lot_params
    params.permit(:title, :description, :current_price, :estimated_price, 
      :lot_start_time, :lot_end_time, :image)
  end

  # set current lot
  def set_lot
    @lot = Lot.find(params[:id])
  end

  # set lots where user is seller or user created some bids
  # def set_my_lots
  #   @my_lots = current_user.lots.paginate(:page => params[:page])
  # end

end
