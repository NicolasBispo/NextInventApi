# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    include RackSessionsFix
    respond_to :json

    private

    def respond_with(_current_user, _opts = {})
      render 'users/show'
    end

    def respond_to_on_destroy
      if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, ENV['DEVISE_JWT_SECRET_KEY']).first
        current_user = User.find(jwt_payload['sub'])
      end

      if current_user
        render json: { status: 200, message: 'Logged out successfully.' }, status: :ok
      else
        render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
      end
    end
  end
end
