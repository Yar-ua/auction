class LotsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_lot, only: [:show, :update, :destroy]
  before_action :set_my_lots, only: [:mylots]

  def index
      @lots = Lot.all
      send_response(200, @lots)
  end

  def mylots
    # TODO
    # Need update ordering by my lots
    send_response(200, @lots)
  end

  def create
    @lot = current_user.lots.build(lot_params)
    if @lot.save
      send_response(200, @lot)
    else
      send_response(422, @lot.errors)
    end
  end

  def show
    send_response(200, @lot)
  end

  def update
    if (@lot.user_id == current_user.id) and (@lot.pending? == true)
      if @lot.valid?
        @lot.update(lot_params)
        send_response(200, @lot)
      else
        send_response(403, @lot.errors)
      end
    else
      send_response(422, 'Forbidden - You are not lot creator, or lot status forbid update (not pending)')
    end
  end

  def destroy
    if (@lot.user_id == current_user.id) and (@lot.pending?)
      @lot.destroy
      send_response(200, 'Lot deleted successfully')
    else
      send_response(422, 'Deleting impossible, you are not owner or lot status is not pending')
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
    @lots = current_user.lots
  end

  # send response JSON
  def send_response(status, data)
    render status: status, json: data.to_json
  end

end
