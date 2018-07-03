class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def index
  	send_response("its ok, my API works")
  end

  def about
  	send_response("Information about API. Forbidden, if you don't loginned")
  end
end
