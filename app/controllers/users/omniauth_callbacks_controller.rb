
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

      email = auth.info.email || generate_temp_email(auth.uid)

      @user = User.from_omniauth(auth, [email])

      if @user.persisted?
         sign_in_and_redirect @user, event: :authentication
         set_flash_message(:notice, :success, kind: 'VKontakte') if is_navigational_format?
      else
         redirect_to new_user_registration_url, alert: "Authentication failed."
      end
   end


   def yandex
      code = request.params['code']
      encoded_credentials = Base64.strict_encode64("#{ENV['YANDEX_CLIENT_ID']}:#{ENV['YANDEX_CLIENT_SECRET']}")
      device_id = SecureRandom.uuid
      device_name = "MyDevDevice"

      begin
         token_response = RestClient.post("https://oauth.yandex.ru/token",
                                          {
                                            grant_type: 'authorization_code',
                                            code: code,
                                            redirect_uri: 'https://dev.andrianoff.online/users/auth/yandex/callback',
                                            device_id: device_id,
                                            device_name: device_name
                                          }.to_query,
                                          {
                                            content_type: 'application/x-www-form-urlencoded',
                                            Authorization: "Basic #{encoded_credentials}"
                                          }
         )


         access_token = JSON.parse(token_response.body)["access_token"]

      rescue RestClient::ExceptionWithResponse => e
         error_response = e.response
         Rails.logger.error "Error: #{error_response}"
         redirect_to root_path, alert: "Authentication failed: #{error_response}"
      end

      user_info = RestClient.get("https://login.yandex.ru/info", {
        Authorization: "Bearer #{access_token}"
      })

      user_data = JSON.parse(user_info.body)

      auth = {
        'provider' => 'yandex',
        'uid' => user_data['id'],
        'info' => {
          'email' => user_data['default_email'],
          'name' => user_data['real_name'] || user_data['display_name'],
          'nickname' => user_data['login']
        }
      }

      @user = User.from_omniauth(auth, [user_data['default_email']])

      if @user.persisted?
         sign_in_and_redirect @user, event: :authentication
         set_flash_message(:notice, :success, kind: 'Yandex') if is_navigational_format?
      else
         redirect_to new_user_registration_url, alert: "Authentication failed."
      end
   end

   private

   def generate_temp_email(uid)
      "#{uid}@vkontakte.com"
   end



end
