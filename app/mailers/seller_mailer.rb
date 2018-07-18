class SellerMailer < ApplicationMailer

  def send_lot_closed_email(lot)
    @user = lot.user
    @lot = lot
    @url = ENV['front_app_url'] + '/lots/' + @lot.id.to_s
    mail(to: @user.email, subject: 'Your lot ' + @lot.title + ' was successfully sold')
  end

  def send_lot_closed_by_timeout_email(lot)
    @user = lot.user
    @lot = lot
    @url = ENV['front_app_url'] + '/lots/' + @lot.id.to_s
    mail(to: @user.email, subject: 'Your lot ' + @lot.title + ' wasnt sold - sold time is out')
  end

end
