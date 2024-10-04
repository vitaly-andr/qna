
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

end
