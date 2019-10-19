require 'sinatra'
require 'sinatra/swagger-exposer/swagger-exposer'
require 'json'
require 'app/helpers'

module ArraysInQueryValueProcessor
  def validate_value(value)
    if value and not value.is_a? Array and value.respond_to?(:split)
      value.split(",").collect {|i| @processor_for_values.validate_value(i) }
    else
      super(value)
    end
  end
end

module Sinatra
  module SwaggerExposer
    module Processing
      class SwaggerArrayValueProcessor
        prepend ArraysInQueryValueProcessor
      end
    end
  end
end

module Controllers
  class Base < Sinatra::Application
    helpers Helpers::Authentication
    register Sinatra::SwaggerExposer

    private

    def self.require_role(role)
      condition do
        unless current_user && (current_user.is_admin? || current_user.roles.include?(role.to_s))
          # CONFIG pretend_admin
          unless CONFIG.pretend_admin
            content_type :json
            halt 403, JSON.generate(code: 403, message:"Not allowed to access this path")
          end
        end
      end
    end

    type 'Error', {
        :required => [:code, :message],
        :properties => {
          :code => {
            :type => Integer,
            :example => 404,
            :description => 'The error code',
          },
          :message => {
            :type => String,
            :example => 'Pet not found',
            :description => 'The error message',
          },
        },
      }

    def self.standard_errors(rest)
      {
        400 => ["Error", "Error"],
        404 => ["Error", "Not found"],
        500 => ["Error", "Internal Error"],
      }.merge(rest)
    end

    def not_found(type, id)
      err(404, "Record not found")
    end

    def err(code, message)
      content_type :json
      [code, JSON.generate({code: code, message: message})]
    end

    def json(resp)
      content_type :json
      [200, JSON.generate(resp)]
    end

  end
end
