require 'app/controllers/base'
require 'app/models'

module Controllers
  class AuthenticationController < Controllers::Base
    endpoint description: "Is user (cookie) logged in?",
      responses: {
        200 => [],
        403 => []},
      parameters: {}
    get "/logged_in" do
      if current_user || CONFIG.pretend_admin
        json({msg: "Logged In"})
      else
        halt 403
      end
    end

    endpoint description: "User sign in action",
      responses: {
        200 => [],
        400 => [],
        403 => []},
      parameters: {
        username: ["Username", :query, true, String],
        password: ["Password", :query, true, String]
      }
    post "/sign_in" do
      user =  User.first(:username => params[:username])

      if user && user.password == params[:password]
        session.clear
        session[:user_id] = user.id
        json({msg: "OK"})
      else
        halt 403
      end
    end

    endpoint description: "User sign out action",
      responses: {200 => []},
      parameters: {}
    post "/sign_out" do
      session.clear
      json({msg: "OK"})
    end
  end
end
