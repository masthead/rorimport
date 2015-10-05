require 'test_helper'

class Sendgrid::GridhookControllerTest < ActionController::TestCase

  test 'should return ok' do
    webhook_data = [
        {
            "email"     => "john.doe@sendgrid.com",
            "timestamp" => 1337197600,
            "smtp-id"   => "<4FB4041F.6080505@sendgrid.com>",
            "event"     => "processed"
        },
        {
            "email"     => "john.doe@sendgrid.com",
            "timestamp" => 1337966815,
            "category"  => "newuser",
            "event"     => "click",
            "url"       => "https://sendgrid.com"
        },
        {
            "email"     => "john.doe@sendgrid.com",
            "timestamp" => 1337969592,
            "smtp-id"   => "<20120525181309.C1A9B40405B3@Example-Mac.local>",
            "event"     => "group_unsubscribe",
            "asm_group_id"=> 42
        }
    ]
    post :create, :_json => webhook_data

    assert_response :success
  end

end