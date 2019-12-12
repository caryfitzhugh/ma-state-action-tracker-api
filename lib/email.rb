require 'aws-sdk'

HOST = 'nescaum-ccsc-dataservices.com'

def send_changed_email(action_track, user, action)
  body = "Action Track (" + action_track.id.to_s + ") - " + action_track.title
  # Replace sender@example.com with your "From" address.
  # This address must be verified with Amazon SES.
  sender = "alert@" + HOST

  # The email body for recipients with non-HTML email clients.
  textbody = body

  # Specify the text encoding scheme.
  encoding = "UTF-8"

  subject = "Private [" + action_track.title + "] was " + action

  (CONFIG.private_action_track_changes_recipients || "").split(",").each do |to_email|
    _send_email( subject: subject,
                recipient: to_email,
                sender: sender,
                html: body)
  end
end

def send_contact_email(to, subject)
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
