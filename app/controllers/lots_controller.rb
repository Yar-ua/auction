class LotsController < ApplicationController

  def index
      @lots = Lot.all
      render :json => {
        :status => :ok,
        :message => @lots
      }.to_json
  end

  def mylots
    @lots = Lot.where(user_id: 1)
    render :json => {
      :status => :ok,
      :message => @lots
    }.to_json
  end

  def create
    #
  end

  def show
    #
  end

  def edit
    #
  end

  def update
    #
  end

  def destroy
    #
  end

end
