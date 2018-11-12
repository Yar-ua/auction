class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lot
  before_action :check_customer, only: [:create, :delivered]
  before_action :check_seller, only: [:sent]

  def create
    @order = @lot.build_order(order_params)
    @order.arrival_status = "pending"
    if @order.save
      send_response(@order)
    else
      send_response(@order.errors, 403)
    end
  end

  def sent
    @lot.order.sent!
    send_response(@lot.order, 200)
  end

  def delivered
    @lot.order.delivered!
    send_response(@lot.order, 200)
  end

  private

  # set current lot
  def set_lot
    @lot = Lot.find(params[:lot_id])
  end

  def order_params
    params.permit(:arrival_type, :arrival_location)
  end

  def check_customer
    @bid = Bid.where(lot_id: @lot.id, is_winner: true).first
    if ((@bid.is_winner == true) and (current_user != @lot.user) and (current_user == @bid.user))
      return true
    else
      raise Exception.new('Forbidden! Only customer can change this status')
    end
  end

  def check_seller
    if current_user == @lot.user
      return true
    else
      raise Exception.new('Forbidden! Only seller can change this status')
    end
  end

end
