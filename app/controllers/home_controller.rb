class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def index
  	render :json => "its ok, my API works", status: :ok
  end

  def about
  	render :json => "Information about API. Forbidden, if you don't loginned", status: :ok
  end
end
