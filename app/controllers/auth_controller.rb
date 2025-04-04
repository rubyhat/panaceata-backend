# frozen_string_literal: true

class AuthController < ApplicationController
  before_action :authenticate_user!, only: [ :me ]

  # POST /auth/login
  def login
    user = User.find_by(email: params[:email])

    unless user&.authenticate(params[:password])
      return render json: { error: "Неверный email или пароль" }, status: :unauthorized
    end

    access_token = JwtService.generate_access_token(user)
    refresh_token = JwtService.generate_refresh_token(user)

    render json: {
      access_token: access_token,
      refresh_token: refresh_token,
      user: {
        id: user.id,
        role: user.role,
        clinic_id: user.clinic_id
      }
    }, status: :ok
  end

  # POST /auth/refresh
  def refresh
    token = params[:refresh_token]
    payload = JwtService.decode(token)

    user = User.find(payload["user_id"])

    access_token = JwtService.generate_access_token(user)
    refresh_token = JwtService.generate_refresh_token(user)

    render json: {
      access_token: access_token,
      refresh_token: refresh_token
    }, status: :ok
  rescue JWT::DecodeError, JWT::ExpiredSignature => e
    render json: { error: e.message }, status: :unauthorized
  end

  # POST /auth/logout
  def logout
    # Пока не инвалидируем refresh_token, но это можно будет реализовать через Redis или таблицу token_versions
    head :no_content
  end

  # GET /auth/me
  def me
    render json: {
      id: current_user.id,
      email: current_user.email,
      role: current_user.role,
      clinic_id: current_user.clinic_id
    }
  end
end
