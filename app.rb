File.expand_path(File.dirname(__FILE__)).tap {|pwd| $LOAD_PATH.unshift(pwd) unless $LOAD_PATH.include?(pwd)}
require 'lib/utils'
require 'lib/ilike'
autoload :CONFIG, 'lib/config'
autoload :OpenStruct, 'ostruct'
require 'sinatra'
require 'sinatra/base'
require 'logger'
require 'colorize'
require 'sinatra/cross_origin'
require 'sinatra/swagger-exposer/swagger-exposer'


require 'app/controllers/authentication_controller'
require 'app/controllers/action_statuses_controller'
require 'app/controllers/action_types_controller'
require 'app/controllers/agency_priorities_controller'
require 'app/controllers/exec_offices_controller'
require 'app/controllers/funding_sources_controller'
require 'app/controllers/global_actions_controller'
require 'app/controllers/lead_agencies_controller'
require 'app/controllers/partners_controller'
require 'app/controllers/primary_climate_interactions_controller'
require 'app/controllers/progress_notes_controller'
require 'app/controllers/shmcap_goals_controller'
require 'app/controllers/users_controller'

# Needs to be *last*
require 'app/controllers/action_tracks_controller'

require 'app/helpers'

set :logger, Logger.new(STDOUT)
set :logging, Logger::DEBUG
set :method_override, true
set :public_folder, File.dirname(__FILE__) + '/public'

set :allow_origin, :any
set :allow_methods, [:get, :put, :delete, :post, :options]
set :allow_credentials, true
set :max_age, "1728000"
set :port, 5000
set :expose_headers, ['Content-Type']
set :protection, except: [:http_origin]

class App < Sinatra::Application
  register Sinatra::SwaggerExposer
  register Sinatra::CrossOrigin


  use Rack::Session::Cookie, :key => 'rack.session',
                             :expire_after => 60 * 60 * 24, # 1 day
                             :secret => ENV["SESSION_SECRET"],
                             :old_secret => ENV["OLD_SESSION_SECRET"]

  configure do
    enable :cross_origin
  end

  before do
    logger.level = 0
  end

  general_info(
    {
      version: '0.0.1',
      title: 'MA State Action Tracker / NESCAUM Data Services',
      description: 'MA State Action Tracker / NESCAUM Data Services',
      license: {
        name: 'Copyright NESCAUM 2019-2019',
      }
    }
  )
  helpers Helpers::Authentication

  use Controllers::AuthenticationController

  use Controllers::ActionTypesController
  use Controllers::ActionStatusesController
  use Controllers::ActionTracksController
  use Controllers::AgencyPrioritiesController
  use Controllers::ExecOfficesController
  use Controllers::FundingSourcesController
  use Controllers::GlobalActionsController
  use Controllers::LeadAgenciesController
  use Controllers::PartnersController
  use Controllers::PrimaryClimateInteractionsController
  use Controllers::ProgressNotesController
  use Controllers::ShmcapGoalsController
  use Controllers::UsersController

  get "/healthcheck", :no_swagger => true do
    "OK"
  end

  get "/", :no_swagger => true do
    redirect '/index.html'
  end

  options "*", :no_swagger => true do
    response.headers["Access-Control-Allow-Credentials"] = "true"
    response.headers["Access-Control-Allow-Origin"] =  env["HTTP_ORIGIN"]
    response.headers["Access-Control-Allow-Methods"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Authorization, X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Set-Cookie, Cookie, withcredentials, *"
    200
  end
end
