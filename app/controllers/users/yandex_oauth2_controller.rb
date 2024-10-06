class Users::YandexOauth2Controller < ApplicationController
  def new
    # client = OAuth2::Client.new(
    #   ENV['YANDEX_CLIENT_ID'],
    #   ENV['YANDEX_CLIENT_SECRET'],
    #   site: 'https://oauth.yandex.ru',
    #   authorize_url: '/authorize',
    #   token_url: '/token'
    # )

    # Now you can use the client to generate the authorization URL and redirect the user
    redirect_to "https://oauth.yandex.ru/authorize?client_id=#{ENV['YANDEX_CLIENT_ID']}&redirect_uri=#{yandex_oauth2_callback_url}&response_type=code", allow_other_host: true
  end

  def callback
    Rails.logger.debug "Session content beginning: #{session.to_hash}"
    Rails.logger.debug "Params code: #{params[:code]}"
    if session[:used_code] == params[:code]
      Rails.logger.debug "OAuth code already used."
      return # Prevent processing the code again
    end
    session[:used_code] = params[:code]

    client = OAuth2::Client.new(
      ENV['YANDEX_CLIENT_ID'],
      ENV['YANDEX_CLIENT_SECRET'],
      site: 'https://oauth.yandex.ru',
      authorize_url: '/authorize',
      token_url: '/token'
    )

    # Exchange the authorization code for an access token
    encoded_credentials = Base64.strict_encode64("#{ENV['YANDEX_CLIENT_ID']}:#{ENV['YANDEX_CLIENT_SECRET']}")

    # Exchange the authorization code for an access token with the encoded header
    token = client.auth_code.get_token(
      params[:code],
      redirect_uri: yandex_oauth2_callback_url,
      headers: {
        'Authorization' => "Basic #{encoded_credentials}"
      }
    )
    # Make a request to Yandex to get the user information
    user_info_response = token.get('https://login.yandex.ru/info', headers: { 'Authorization' => "Bearer #{token.token}" })
    user_info = user_info_response.parsed

    # Here you would typically find or create a user in your database
    # based on the information retrieved from Yandex, and then sign them in
    email = user_info['default_email'].downcase if user_info['default_email']
    Rails.logger.debug "Session content: #{session.to_hash}"

    @user = User.from_omniauth(user_info, [email])

    if @user.persisted?
      Rails.logger.debug "Session content before: #{session.to_hash}"
      sign_in_and_redirect @user
      Rails.logger.debug "Session content after: #{session.to_hash}"
    else
      redirect_to new_user_registration_url
    end
  end
end
