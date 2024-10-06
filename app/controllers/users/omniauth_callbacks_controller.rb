
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

   def generate_temp_email(uid, provider)
      "#{uid}@#{provider}.com"
   end

end
