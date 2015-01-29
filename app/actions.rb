# Homepage (Root path)
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

get '/home' do
    erb :home
end

get '/home/create' do
    erb :'home/create'
end

post '/home/create' do
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


get '/home/event/:event_id' do
    erb :'home/event/event_id'
end

get '/home/:event_id/:follower_id' do
    erb :'home/event_id/follower_id'
end

post '/home/:event_id/:follower_id' do
    # follower = Follower.where(event_id: params[:event_id], id: params[:id])
    # follower[:unit_quantity] = params[:unit_quantity]
    # follower[:unit_total_price] = follower[:unit_quantity] * follower.event.unit_price
    # # follower[:stripe_token] = params[:stripe_token]
    # #follower[:status] = 

    # redirect '/thank_you'
end

get '/thank_you' do
    erb :thank_you
end

get '/why' do
    erb :why
end




