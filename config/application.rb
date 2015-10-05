require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'marginalia/railtie'

if defined?(Bundler)
    Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module RedpointRack
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.secret_key_base = '5mdrYMd2234209sdfjjskFDK3902oE1s4ljhHET'
    config.beginning_of_week = :sunday

    config.active_record.raise_in_transactional_callbacks = true
    config.assets.paths << Rails.root.join('app', 'assets', 'javascripts', 'angular', 'templates')
    config.assets.paths << Rails.root.join('app', 'assets', 'stylesheets', 'theme')
    config.action_mailer.preview_path = "#{Rails.root}/app/mailer_previews"

    # sentry
    Raven.configure do |config|
      config.environments = %w{ production staging }
    end
  end
end

Timezone::Configure.begin do |c|
  c.username = 'pasperry'
end
