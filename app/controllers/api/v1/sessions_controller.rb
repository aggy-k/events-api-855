class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :verify_request, only: [:login]

  def login
    # Recap of what needs to happen in login
    # 1 - Rails sends the code to Tencent along with app secret and app id
    user = find_user

    token = jwt_encode(user_id: user.id) # put user_id in payload
    render json: {
      headers: { "X-USER-TOKEN" => token },
      user: user
    }
  end

  private
    def find_user
      # {"session_key":"uPv2K\/1dejP1HfDH7W3s3w==","openid":"on44z5BrFP6tWMRfJcyfbWA7LduU"}
      open_id = fetch_wx_open_id(params[:code])['openid']
      User.find_or_create_by(open_id: open_id)
    end

    def fetch_wx_open_id(code)
      app_id = Rails.application.credentials.dig(:wechat, :app_id)
      app_secret = Rails.application.credentials.dig(:wechat, :app_secret)

      url = "https://api.weixin.qq.com/sns/jscode2session?appid=#{app_id}&secret=#{app_secret}&js_code=#{code}&grant_type=authorization_code"
      response = RestClient.get(url)
      puts "response => #{response}"
      JSON.parse(response)
    end

    def jwt_encode(payload) # generate JWT
      JWT.encode payload, HMAC_SECRET, 'HS256'
    end
end











