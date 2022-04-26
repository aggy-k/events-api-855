class Api::V1::BaseController < ApplicationController
  HMAC_SECRET = Rails.application.credentials.dig(:jwt, :hmac_secret)

  skip_before_action :verify_authenticity_token

  before_action :verify_request

  def verify_request
    token = get_jwt_token

    if token.present?
      data = jwt_decode(token)
      user_id = data[:user_id]
      @current_user = User.find(user_id) # set current user by user_id in JWT payload
    else
      render json: { error: 'Missing JWT token.' }, status: 401
    end

  end

  def jwt_decode(token) # decode JWT, then turn payload into a hash
    decoded_info = JWT.decode(token, HMAC_SECRET, { algorithm: 'HS256' })[0] # extract the payload
    HashWithIndifferentAccess.new decoded_info
    # h['user_id']
    # h[:user_id]
  end

  def get_jwt_token # retrieve token from headers
    request.headers['X-USER-TOKEN']
    # raise
  end
end
