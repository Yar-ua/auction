class LotsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_lot, only: [:show, :update, :destroy]
  before_action :set_my_lots, only: [:mylots]

  WillPaginate.per_page = 10

  def index
      @lots = Lot.all.paginate(:page => params[:page])
      send_response(@lots)
  end

  def mylots
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
    send_response(@lot)
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
      :lot_start_time, :lot_end_time)
  end

  # set current lot
  def set_lot
    @lot = Lot.find(params[:id])
  end

  # set lots where user is seller or user created some bids
  def set_my_lots
    @my_lots = current_user.lots.paginate(:page => params[:page])
  end

end