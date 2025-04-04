# frozen_string_literal: true

# @see ApplicationController
# Модуль добавляет методы аутентификации на основе JWT.
# Устанавливает current_user и проверяет access_token в заголовке.
module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
    helper_method :current_user
  end

  # @return [User, nil] текущий пользователь, если токен валиден
  def current_user
    @current_user
  end

  # Проверяет наличие и валидность access_token
  # Если токен отсутствует или недействителен, возвращает 401 Unauthorized
  def authenticate_user!
    return if current_user.present?

    render json: { error: "Необходима авторизация" }, status: :unauthorized
  end

  private

  # Извлекает access_token, декодирует и устанавливает @current_user
  def set_current_user
    auth_header = request.headers["Authorization"]
    return if auth_header.blank?

    token = auth_header.split(" ").last
    payload = JwtService.decode(token)

    @current_user = User.find_by(id: payload["user_id"])
  rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound
    @current_user = nil
  end
end
