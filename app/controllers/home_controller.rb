class HomeController < ApplicationController
  def index
  	render :json => "its ok, my API works", status: :ok
  end
end
