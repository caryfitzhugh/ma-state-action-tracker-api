require 'app/controllers/base'
require 'app/models'
require 'uri'
require 'lib/email'

module Controllers
  class ContactUsController < Controllers::Base
    type 'ContactUsResponse', {
      properties: {
        message: {type: String, description: "result"}
      }
    }
    type 'ContactUsMessage', {
      properties: {
        message: {type: String, description: "message to send"},
        first_name: {type: String, description: "First name of sender"},
        last_name: {type: String, description: "Last name of sender"},
        captcha: {type: String, description: "captcha value"},
        email: {type: String, description: "email of the system"},
      }
    }

    # CREATE
    endpoint description: "Create Action Status",
      responses: standard_errors( 200 => "ActionStatusResponse"),
      parameters: {
        data: ["ContactUsMessage", :body, true, 'ContactUsMessage'],
      },
      tags: ["Contact Us"]
    post '/contact-us/?' do
      uri = URI.parse('https://www.google.com/recaptcha/api/siteverify')

      req_params = {
        'secret' => CONFIG.captcha_key,
        'response'   => params['parsed_body']['data']['captcha']
      }
      res = Net::HTTP.post_form(uri, req_params)

      json_res = JSON.parse res.body if res.is_a?(Net::HTTPSuccess)

      if json_res and json_res['success'] != true
        json({message: "Invalid Captcha. " + json_res['error-codes'].join(",")})
      else
        data = params['parsed_body']['data']
        (CONFIG.contact_email_recipients || "").split(",").each do |to_email|
          send_contact_email(to_email, "MA State Action Tracker Contact Submission") do
            """
            First: #{data['first_name']}
            Last: #{data['last_name']}
            Email: #{data['email']}
            Message:
              #{data['message']}
            """
          end
        end

        json({message: "Sent"})
      end
    end
  end
end
