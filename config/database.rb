configure do
  # Log queries to STDOUT in development
  if Sinatra::Application.development?
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  set :database, {
  adapter: 'postgresql',
  encoding: 'unicode',
  pool: 5,
  database: 'd7s748bu40hutt',
  username: 'vxbsgvrbpnsesf',
  password: '2MU3GXeMRa3VyzdL49czc6iUvC',
  host: 'ec2-184-73-165-193.compute-1.amazonaws.com',
  port: 5432,
  min_messages: 'error'
}
puts "CONNECTED"


  # Load all models from app/models, using autoload instead of require
  # See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end

end

