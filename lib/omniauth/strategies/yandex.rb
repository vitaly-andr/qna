# require 'omniauth-oauth2'
#
# module OmniAuth
#   module Strategies
#     class Yandex < OmniAuth::Strategies::OAuth2
#       option :name, 'yandex'
#
#       option :client_options, {
#         site: 'https://oauth.yandex.ru',
#         authorize_url: '/authorize',
#         token_url: '/token'
#       }
#       def callback_phase
#         Rails.logger.debug "Yandex callback_phase initiated"
#         Rails.logger.debug "Received params: #{request.params.inspect}"
#
#         # Log the session before calling super
#         Rails.logger.debug "Session before calling super in callback_phase: #{session.to_hash}"
#
#         # Call the original callback_phase method
#         super
#       # rescue ::OAuth2::Error, CallbackError => e
#       #   Rails.logger.error "Yandex OAuth2 error: #{e.inspect}"
#       #   fail!(:invalid_credentials, e)
#       end
#
#       # Method to retrieve raw user info from Yandex
#       def raw_info
#         # Make a request to Yandex for user info with the access token
#         @raw_info ||= access_token.get('https://login.yandex.ru/info').parsed
#       end
#
#       uid { raw_info['id'] }
#
#       info do
#         {
#           name: raw_info['real_name'] || raw_info['display_name'],
#           email: raw_info['default_email'],
#           first_name: raw_info['first_name'],
#           last_name: raw_info['last_name']
#         }
#       end
#
#       extra do
#         { 'raw_info' => raw_info }
#       end
#     end
#   end
# end
