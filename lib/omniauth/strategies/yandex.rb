require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Yandex < OmniAuth::Strategies::OAuth2
      option :name, 'yandex'

      option :client_options, {
        site: 'https://oauth.yandex.ru',
        authorize_url: '/authorize',
        token_url: '/token'
      }
      def authorize_params
        super.tap do |params|
          Rails.logger.debug "Authorization URL params: #{params.to_query}"
        end
      end
      def request_phase

        authorization_url = client.auth_code.authorize_url({
                                                             client_id: options.client_id,
                                                             response_type: 'code',
                                                             scope: authorize_params[:scope],
                                                             state: authorize_params[:state]
                                                           })

        Rails.logger.debug "Redirecting to: #{authorization_url}"
        redirect authorization_url
      end
    end
  end
end
