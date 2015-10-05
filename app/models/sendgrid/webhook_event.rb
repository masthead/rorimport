class Sendgrid::WebhookEvent < ActiveRecord::Base

  belongs_to :sendgrid_webhook, :class => Sendgrid::Webhook, :foreign_key => :sendgrid_webhook_id

  store_accessor :newsletter, :newsletter_user_list_id
  store_accessor :newsletter, :newsletter_id
  store_accessor :newsletter, :newsletter_send_id

end