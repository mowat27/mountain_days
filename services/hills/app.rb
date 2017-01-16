require 'sinatra/base'
require 'sinatra/reloader'

require 'json'

require_relative 'lib/mountain_days'

class App < Sinatra::Base
  include MountainDays

  def self.hydrated_read_model
    ReadModel.hydrate(
      hills: App::FILES.munros,
      locations: App::FILES.locations,
      starting_points: App::FILES.starting_points,
    )
  end

  configure :development do
    register Sinatra::Reloader
    set :read_model, hydrated_read_model
  end

  get '/' do
    <<-EOS
    <h3>Read Model Contains #{settings.read_model.hills.count} hills</h3>
    <form action="/read-model/clear" method=post>
      <button type="submit">Clear Read Model</button>
    </form>
    <form action="/read-model/hydrate" method=post>
      <button type="submit">Hydrate Read Model</button>
    </form>
    EOS
  end

  get '/read-model.json' do
    settings.read_model.to_h.to_json
  end

  post '/read-model/clear' do
    settings.read_model = ReadModel.new
    redirect '/'
  end

  post '/read-model/hydrate' do
    settings.read_model = self.class.hydrated_read_model
    redirect '/'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
