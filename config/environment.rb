
Sinatra::Base.configure :production, :development, :test do 

	set :server, :puma 
	set :threaded, true

	# Bootstrap MongoDB connection
	Mongoid.load! "./config/mongoid.yml"  # we are running this method from top-level

	db = URI.parse(ENV['DATABASE_URL'] || "postgres://localhost/places_api_#{ENV["RACK_ENV"]}")

	ActiveRecord::Base.establish_connection(
		:adapter   => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
		:host      => db.host,
		:username  => db.user,
		:password  => db.password,
		:database  => db.path[1..-1],
		:encoding  => 'utf8'
		)
end