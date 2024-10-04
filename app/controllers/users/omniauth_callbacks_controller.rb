
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

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


   def yandex
      auth = request.env['omniauth.auth']

      token = auth['credentials']['token']

      begin
         user_info_response = RestClient.get('https://login.yandex.ru/info', {
           Authorization: "Bearer #{token}"
         })

         user_info = JSON.parse(user_info_response.body)

         auth['uid'] = user_info['id']
         auth['info'] ||= {}
         auth['info']['name'] = user_info['real_name'] || user_info['display_name'] || "#{user_info['first_name']} #{user_info['last_name']}".strip
         auth['info']['email'] = user_info['default_email'] || auth.info.email
         auth['info']['first_name'] = user_info['first_name']
         auth['info']['last_name'] = user_info['last_name']

      rescue RestClient::ExceptionWithResponse => e
         Rails.logger.error "Failed to fetch user info from Yandex: #{e.response}"
         redirect_to root_path, alert: "Failed to fetch user information from Yandex."
         return
      end

      email = auth.info.email || generate_temp_email(auth['uid'], 'yandex')

      @user = User.from_omniauth(auth, [email])

      if @user.persisted?
         sign_in_and_redirect @user, event: :authentication
         set_flash_message(:notice, :success, kind: 'Yandex') if is_navigational_format?
      else
         redirect_to new_user_registration_url, alert: "Authentication failed."
      end
   end

   def generate_temp_email(uid, provider)
      "#{uid}@#{provider}.com"
   end



end
