require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Yandex < OmniAuth::Strategies::OAuth2
      option :name, 'yandex'

      option :client_options, {
        site: 'https://oauth.yandex.com',
        authorize_url: '/authorize',
        token_url: '/token'
      }
    end
  end
end
