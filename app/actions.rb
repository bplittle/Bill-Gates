# Homepage (Root path)
require "stripe"



get '/' do
  erb :index
end

get '/sign_up' do
    erb :sign_up
end

post '/new_user' do
    # form fields into new user

    # new_leader = Leader.create(
    #     leader_name: params[:name],
    #     leader_email: params[:email],
    #     password: params[:password],
    #     leader_stripe_key: params[:key])

    # if new_leader.save
        # session[:leader_id] = new_leader.id
        # redirect '/home'
    # else
    #     redirect '/'
    # end
    
end

get '/events' do
    erb :index
end

get '/events/new' do
    erb :'events/new'
end

post '/events/new' do
    #form fields into new event

    new_event = Event.create(
        event_name: params[:name],
        date: params[:date],
        time: params[:time],
        location: params[:location],
        event_url: params[:event_url],
        unit_price: params[:unit_price])

    new_event.save

    emails = params[:emails].split(', ')
    emails.each do |email|
        follower = Follower.create(follower_email: email, event_id: new_event.id)
        follower.save
    end

    redirect '/'

    # binding.pry
    
    # Send emails to followers with that event id
end


get '/events/:event_id' do

		@event = Event.find(params[:event_id])

    erb :'events/show'
end

post '/events/:event_id' do
 
## take payment from folloewrs
	event = Event.find(params[:id])

	event.followers.each do |follower|
		follower[:stripe_token].capture
	end

	redirect '/events'

end

post '/events/:event_id/decline/:follower_id' do

	follower = Follower.where(event_id: params[:event_id], id: params[:follower_id]).first
	follower[:status] = "declined"
	follower.save!

	redirect '/events'

end

post '/events/:event_id/:follower_id' do
# binding.pry
follower = Follower.where(event_id: params[:event_id], id: params[:follower_id]).first
follower[:follower_name] = params[:name].to_s
follower[:unit_quantity] = params[:unit_quantity].to_i
follower[:unit_total_price] = follower[:unit_quantity].to_i * Event.find(params[:event_id]).unit_price
follower[:status] = params[:status]

 p follower[:follower_name]

       @amount = 2000

 Stripe.api_key = "sk_test_i4TQCuPANmpmhYs6I9YXgV4m"

 puts "strike api key received"

# Get the credit card details submitted by the form
token = params[:stripeToken]
p token

# Create the charge on Stripe's servers - this will charge the user's card

  charge = Stripe::Charge.create(
    :amount => 1000, # amount in cents, again
    :currency => "cad",
    :card => token,
    :description => "payinguser@example.com",
    :capture => false
  )
# rescue Stripe::CardError => e
#   # The card has been declined



 	follower[:stripe_token] = charge.id
 	if follower.save
 		follower[:status] = "confirmed"
 		puts "success"
 	end

  redirect '/events'
     
end

post '/events' do
	#add id back in later to specify event

	Stripe.api_key = "sk_test_i4TQCuPANmpmhYs6I9YXgV4m"

	ch = Stripe::Charge.retrieve("ch_15QoUXFR7CapK6EtvYMQZC2P")
	binding.pry
	ch.capture

	redirect '/'

end

get '/events/:event_id/:follower_id' do
    @unit_price = Event.find(params[:event_id]).unit_price
    @event_id = params[:event_id]
    @follower_id = params[:follower_id]
    erb :'follower/new'
end



get '/thank_you' do
    erb :thank_you
end

get '/about' do
    erb :about
end




