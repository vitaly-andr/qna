
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

      if auth.info.email.nil?
         email = generate_temp_email(auth.uid, 'vkontakte')
         email_generated = true
      else
         email = auth.info.email
         email_generated = false
      end

      @user, temporary_password = User.from_omniauth(auth, [email], email_generated)

      if @user.persisted?
         session[:temporary_password] = temporary_password

         sign_in @user, event: :authentication
         set_flash_message(:notice, :success, kind: 'VKontakte') if is_navigational_format?

         if @user.confirmed?
            redirect_to root_path
         else
            redirect_to edit_user_registration_path, notice: 'Please update and confirm your email and create new password'
         end
      else
         redirect_to new_user_registration_url, alert: "Authentication failed."
      end
   end

   def generate_temp_email(uid, provider)
      "#{uid}@#{provider}.com"
   end

end
