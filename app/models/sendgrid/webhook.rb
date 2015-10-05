class Sendgrid::Webhook < ActiveRecord::Base

  belongs_to :noticeable, :polymorphic => true

  has_many :sendgrid_webhook_events, :class => Sendgrid::WebhookEvent, :foreign_key => :sendgrid_webhook_id

  validates_presence_of :category
  validates_uniqueness_of :category

  class << self
    def update_from_feed(data)
      if data.present?
        data.each do |row|
          if row[:category]
            if row[:category].is_a?(Array)
              # do not process yet
            else
              fetched = self.where(:category => row[:category]).first
              if fetched
                webhook_event = fetched.sendgrid_webhook_events.create(
                  :email      => row[:email],
                  :timestamp  => row[:timestamp],
                  :smtp_id    => row["smtp-id".to_sym],
                  :event      => row[:event],
                  :url        => row[:url],
                  :userid     => row[:userid],
                  :template   => row[:template]
                )
                if row[:newsletter]
                  webhook_event.update_attribute(:newsletter, {
                    :newsletter_user_list_id => row[:newsletter][:newsletter_user_list_id],
                    :newsletter_id           => row[:newsletter][:newsletter_id],
                    :newsletter_send_id      => row[:newsletter][:newsletter_send_id]
                  })
                end
              end
            end
          end
        end
      end
    end
  end
end