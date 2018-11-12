class CustomerMailer < ApplicationMailer

  def send_winning_lot_email(bid)
    @bid = bid
    @lot = @bid.lot
    @user = @bid.user
    @url = ENV["front_app_url"] + '/lots/' + @lot.id.to_s
    mail(to: @user.email, 
      subject: "You are winner in the lot " + @lot.title + 
      " with your bid " + @bid.proposed_price.to_s)
  end

  def order_sent_email(order)
    @order = order
    @lot = order.lot
    @user = User.find( order.lot.bids.where(is_winner: true)[0][:user_id] )
    @url = ENV["front_app_url"] + '/lots/' + @lot.id.to_s
    mail(to: @user.email, subject: "Your lot " + @lot.title + " was sent")
  end
  
end
