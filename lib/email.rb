require 'aws-sdk'

HOST = 'ma-state-action-tracker.nescaum-ccsc-dataservices.com'

def send_alert_email(to, subject)
  body = yield
  # Replace sender@example.com with your "From" address.
  # This address must be verified with Amazon SES.
  sender = "alert@" + HOST

  # The email body for recipients with non-HTML email clients.
  textbody = body

  # Specify the text encoding scheme.
  encoding = "UTF-8"

  _send_email( subject: subject,
               recipient: to,
               sender: sender,
               html: body)
end

def _send_email(subject:,
                recipient:,
                sender:,
                html: )
  awsregion = "us-east-1"

  # Create a new SES resource and specify a region
  ses = Aws::SES::Client.new(region: awsregion)

  encoding = 'UTF-8'

  # Try to send the email.
  begin
    text = html.gsub(/<\/?[^>]*>/, ' ').gsub(/\n\n+/, '\n').gsub(/^\n|\n$/, ' ').squeeze.strip
    # Provide the contents of the email.
    resp = ses.send_email({
      destination: {
        to_addresses: [
          recipient,
        ],
      },
      message: {
        body: {
          html: {
            charset: encoding,
            data: html
          },
          text: {
            charset: encoding,
            data: text
          },
        },
        subject: {
          charset: encoding,
          data: subject,
        },
      },
      source: sender,
    })
    puts "Email sent!"

  # If something goes wrong, display an error message.
  rescue Aws::SES::Errors::ServiceError => error
    puts "Email not sent. Error message: #{error}"
  end
end

def send_feedback_email(feedbacks)
  body = ""
  body += "<h2>#{feedbacks.length} Feedback Messages</h2>"
  body += "<ul>"
  body += feedbacks.map do |f|
            link = "<li>"
            link += "<strong> Name </strong> <p> #{f.name}</p><br/>"
            link += "<strong> Email </strong> <p> #{f.email}</p><br/>"
            link += "<strong> Organization </strong> <p> #{f.organization}</p><br/>"
            link += "<strong> Phone </strong> <p> #{f.phone}</p><br/>"
            link += "<strong> Comment </strong> <p> #{f.comment}</p><br/>"
            link += "<strong> Should Contact </strong> <p> #{f.contact ? 'YES' : 'NO'}</p><br/>"
            link += "</li>"
          end.join("\n")
  body += "</ul>"

  CONFIG.emails.feedback.each do |to|
    puts "Sending to #{to}"
    send_alert_email(to, "#{feedbacks.length} Feedback Responses") do
      body
    end
  end
end

def send_alert_email(to, subject)
  body = yield
  # Replace sender@example.com with your "From" address.
  # This address must be verified with Amazon SES.
  sender = "alert@" + HOST

  # The email body for recipients with non-HTML email clients.
  textbody = body

  # Specify the text encoding scheme.
  encoding = "UTF-8"

  _send_email( subject: subject,
               recipient: to,
               sender: sender,
               html: body)
end

def _send_email(subject:,
                recipient:,
                sender:,
                html: )
  awsregion = "us-east-1"

  # Create a new SES resource and specify a region
  ses = Aws::SES::Client.new(region: awsregion)

  encoding = 'UTF-8'

  # Try to send the email.
  begin
    text = html.gsub(/<\/?[^>]*>/, ' ').gsub(/\n\n+/, '\n').gsub(/^\n|\n$/, ' ').squeeze.strip
    # Provide the contents of the email.
    resp = ses.send_email({
      destination: {
        to_addresses: [
          recipient,
        ],
      },
      message: {
        body: {
          html: {
            charset: encoding,
            data: html
          },
          text: {
            charset: encoding,
            data: text
          },
        },
        subject: {
          charset: encoding,
          data: subject,
        },
      },
      source: sender,
    })
    puts "Email sent!"

  # If something goes wrong, display an error message.
  rescue Aws::SES::Errors::ServiceError => error
    puts "Email not sent. Error message: #{error}"
  end
end
