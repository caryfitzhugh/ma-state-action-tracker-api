require 'app/controllers/base'
require 'app/models'

module Controllers
  class AuthenticationController < Controllers::Base
    endpoint description: "Is user (cookie) logged in?",
      responses: {
        200 => []},
      parameters: {}
    get "/logged_in" do
      if current_user
        json({logged_in: true, roles: Hash[current_user.roles.collect { |item| [item, true] }]})
      else
        json({logged_in: false, roles: {}})
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
        json({logged_in: true, roles: Hash[current_user.roles.collect { |item| [item, true] }]})
      else
        halt 403
      end
    end

    endpoint description: "User sign out action",
      responses: {200 => []},
      parameters: {}
    post "/sign_out" do
      session.clear
      json({msg: "OK", roles: {}})
    end
  end
end
