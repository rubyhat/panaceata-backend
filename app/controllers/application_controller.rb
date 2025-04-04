# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def authenticate_user!
    render json: { error: "Неавторизовано" }, status: :unauthorized unless current_user
  end

  def current_user
    return @current_user if defined?(@current_user)

    auth_header = request.headers["Authorization"]
    token = auth_header.to_s.split(" ").last

    return nil if token.blank?

    begin
      payload = JwtService.decode(token)
      @current_user = User.find_by(id: payload["user_id"])
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end
  end
end
