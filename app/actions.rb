# Homepage (Root path)
require "stripe"



get '/' do
  erb :index
end

post '/' do 
    leader = Leader.find_by(leader_email: params[:leader_email])

    if params[:password] == leader[:password]
        session[:leader_id] = leader.id
        redirect '/events'
    else
        redirect '/'
    end
end

get '/logout' do
    session.clear
    redirect '/'
end

get '/leader/new' do
    erb :'leader/new'
end

post '/leader/new' do

    leader = Leader.new(
        leader_name: params[:leader_name],
        leader_email: params[:leader_email],
        password: params[:password],
        leader_stripe_key: params[:api_key])

    if leader.save
        session[:leader_id] = leader[:id]
        redirect '/events'
    else
        redirect '/leader/new'
    end
end

get '/events' do
    @leader = Leader.find(session[:leader_id])
    erb :events
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
        unit_price: params[:unit_price],
        leader_id: session[:leader_id])

    new_event.save

    emails = params[:emails].split(', ')
    emails.each do |email|
        follower = Follower.create(follower_email: email, event_id: new_event.id)
        follower.save

        m = Mandrill::API.new 'ASPCt1fLpFwKfE7g9rMo9Q'

        message = {
            subject: new_event.leader.leader_name + " has invited you to " + new_event.event_name ,
            from_name: new_event.leader.leader_name,
            text: "Want to come to " + new_event.event_name + "?",
            to: [
                {email: email,
                    name: "Friend of " + new_event.leader.leader_name
                    }],
            html: "<html><h1> Want to come to " + new_event.event_name + " ?</h1> 
            <br>Location: " + new_event.location + "
            <br>Date: " + new_event.date + "
            <br>Unit Price: " + new_event.unit_price.to_s + "
            <br><br>Visit the below url to pre-authorize payback to your friend who will be buying your tickets. They should only charge you once they have purchased your ticket(s). 
            <br><br>localhost:3000/events/" << new_event.id.to_s << "/" << follower.id.to_s << "<html>",
            from_email: new_event.leader.leader_email
        }

        sending = m.messages.send message

    end


    redirect '/events'

    
end


get '/events/:event_id' do

		@event = Event.find(params[:event_id])

    erb :'events/show'
end

post '/events/:event_id/decline/:follower_id' do

	follower = Follower.where(event_id: params[:event_id], id: params[:follower_id]).first
	follower[:status] = "declined"
	follower.save!

	redirect '/thank_you'

end

post '/events/:event_id/:follower_id' do
    # binding.pry
    follower = Follower.where(event_id: params[:event_id], id: params[:follower_id]).first
    follower[:follower_name] = params[:name].to_s
    follower[:unit_quantity] = params[:unit_quantity].to_i
    follower[:unit_total_price] = follower[:unit_quantity].to_i * Event.find(params[:event_id]).unit_price
    follower[:status] = params[:status]

     p follower[:follower_name]


    event = Event.find(params[:event_id])
    user = event.leader
    # binding.pry
    Stripe.api_key = user.leader_stripe_key
    

     # Stripe.api_key = "sk_test_i4TQCuPANmpmhYs6I9YXgV4m"

     puts "strike api key received"

    # Get the credit card details submitted by the form
    token = params[:stripeToken]
    total_price = follower[:unit_total_price] * 100


    # Create the charge on Stripe's servers - this will charge the user's card

      charge = Stripe::Charge.create(
        :amount => total_price, # amount in cents, again
        :currency => "cad",
        :card => token,
        :description => "payinguser@example.com",
        :capture => false
      )
    # rescue Stripe::CardError => e
    #   # The card has been declined


 	follower[:stripe_token] = charge.id
	follower[:status] = "confirmed"
    follower.save!
	puts "success"
    # binding.pry
 	
    redirect '/thank_you'
  # redirect '/events/' + params[:event_id]
     
end

post '/events/:event_id' do
	event = Event.find(params[:event_id])


    user = Leader.find(session[:leader_id])
    Stripe.api_key = user.leader_stripe_key

	# Stripe.api_key = "sk_test_i4TQCuPANmpmhYs6I9YXgV4m"

    event.followers.each do |follower|
         if follower[:stripe_token] != nil   
            charge_token = follower[:stripe_token]
            ch = Stripe::Charge.retrieve(charge_token)
            ch.capture  
        end
    end

    event.captured_status = true
    event.save!


	# ch = Stripe::Charge.retrieve("ch_15QoUXFR7CapK6EtvYMQZC2P")
	# binding.pry
	# ch.capture

	redirect '/events'

end

# post '/events/:event_id' do
 
# ## take payment from folloewrs
#     event = Event.find(params[:id])

#     event.followers.each do |follower|
#         follower[:stripe_token].capture
#     end

#     redirect '/events'

# end

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




