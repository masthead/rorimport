# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RedpointRack::Application.initialize!

# ActionMailer::Base.delivery_method = :smtp
# ActionMailer::Base.smtp_settings = {
#     :user_name => 'johnmaxmiller',
#     :password => '7D6YHrF5',
#     :domain => 'dealerfocus.com',
#     :address => 'smtp.sendgrid.net',
#     :port => 587,
#     :authentication => :plain,
#     :enable_starttls_auto => true
# }