class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?

  # send response JSON
  def send_response(data, status = 200)
    render status: status, json: data.to_json
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone, :first_name, 
    	:last_name, :birth_day])
  end
end
