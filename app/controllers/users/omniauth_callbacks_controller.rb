
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
   # skip_before_action :verify_authenticity_token, only: :yandex

   def github
      auth = request.env['omniauth.auth']
      token = auth['credentials']['token']

      response = RestClient.get('https://api.github.com/user/emails', { Authorization: "token #{token}" })
      emails = JSON.parse(response.body).map { |email| email['email'] }

      @user = User.from_omniauth(auth, emails)

      sign_in_and_redirect @user
   end

   def google_oauth2
      auth = request.env['omniauth.auth']

      @user = User.from_omniauth(auth, [auth.info.email])
      sign_in_and_redirect @user
   end

   def vkontakte
      auth = request.env['omniauth.auth']

      email = auth.info.email || generate_temp_email(auth.uid, 'vkontakte')

      @user = User.from_omniauth(auth, [email])

      if @user.persisted?
         sign_in_and_redirect @user, event: :authentication
         set_flash_message(:notice, :success, kind: 'VKontakte') if is_navigational_format?
      else
         redirect_to new_user_registration_url, alert: "Authentication failed."
      end
   end

   # def yandex
   #    auth = request.env['omniauth.auth']
   #
   #    if auth.nil?
   #       Rails.logger.error "OmniAuth Yandex auth data is missing."
   #       redirect_to new_user_registration_url, alert: "Authentication failed."
   #       return
   #    end
   #
   #    # Логируем токен
   #    token = auth['credentials']['token']
   #    if token.present?
   #       Rails.logger.debug "Yandex token: #{token}"
   #    else
   #       Rails.logger.error "Yandex token not found!"
   #       redirect_to new_user_registration_url, alert: "Authentication failed."
   #       return
   #    end
   #    user_info = auth['info']
   #    Rails.logger.debug "Yandex user info: #{user_info}"
   #    email = user_info['email'].downcase if user_info['email']
   #    email ||= generate_temp_email(auth['uid'], 'yandex')
   #
   #    @user  = User.from_omniauth(auth, [ email ])
   #    # = last_auth_code
   #
   #    if @user.persisted?
   #       Rails.logger.debug "Session before sign_in: #{session.to_hash}"
   #       sign_in(@user)
   #
   #       Rails.logger.info "User #{@user.email} signed in successfully."
   #       Rails.logger.info "Session after sign_in: #{session.to_hash}"
   #       Rails.logger.info "Current user after sign_in: #{current_user.inspect}"
   #       # Логирование запроса
   #       Rails.logger.info "Request method: #{request.request_method}"
   #       Rails.logger.info "Request URL: #{request.url}"
   #       Rails.logger.info "Request IP: #{request.remote_ip}"
   #       Rails.logger.info "Request parameters: #{request.params.inspect}"
   #       Rails.logger.info "Request headers: #{request.headers.inspect}"
   #
   #       # Логирование ответа
   #       Rails.logger.info "Response status: #{response.status}"
   #       Rails.logger.info "Response headers: #{response.headers.inspect}"
   #       Rails.logger.info "Response body: #{response.body}"
   #
   #       # Редирект на главную страницу
   #       if user_signed_in?
   #          Rails.logger.debug "after sign_in: #{session.to_hash}"
   #       end
   #       Rails.logger.debug "Session after sign_in: #{session.to_hash}"
   #       redirect_to rewards_path, allow_other_host: false
   #    else
   #       redirect_to new_user_registration_url, alert: "Authentication failed."
   #    end
   # end
   # def failure
   #    Rails.logger.error "OmniAuth authentication failed: #{failure_message}"
   #    Rails.logger.debug "Session after failure: #{session.to_hash}"
   #
   #    super
   #    # redirect_to root_path
   # end
   def generate_temp_email(uid, provider)
      "#{uid}@#{provider}.com"
   end

end
