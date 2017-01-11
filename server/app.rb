require 'sinatra/base'
require 'sinatra/reloader'

require_relative '../lib/mountain_days'

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  include MountainDays

  def initialize(*args)
    super(*args)
    @read_model = ReadModel.hydrate(
      hills: App::FILES.munros,
      locations: App::FILES.locations,
      starting_points: App::FILES.starting_points,
    )
  end

  get '/' do
    "Read Model Contains #{@read_model.hills.count} hills"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
