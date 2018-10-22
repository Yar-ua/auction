class OrdersController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_lot
  before_action :check_customer, only: [:create, :delivered]
  before_action :check_seller, only: [:sent]

  def create
    @order = @lot.order.build(order_params)
    if @order.save
      send_response(@order)
    else
      send_response(@order.errors, 403)
    end
  end

  def sent
    @lot.order.sent!
  end

  def delivered
    @lot.order.delivered!
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
    # if (current_user != @lot.user) and 
  end

  def check_seller
    #
  end

end
