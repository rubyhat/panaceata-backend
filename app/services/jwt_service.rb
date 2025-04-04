# frozen_string_literal: true

require "jwt"

# JwtService предоставляет методы для генерации и валидации access и refresh токенов
class JwtService
  ACCESS_EXPIRATION = 15.minutes
  REFRESH_EXPIRATION = 30.days
  ALGORITHM = "HS256"

  class << self
    # Генерация access_token
    # @param user [User]
    # @return [String] JWT access token
    def generate_access_token(user)
      payload = {
        user_id: user.id,
        role: user.role,
        clinic_id: user.clinic_id,
        exp: ACCESS_EXPIRATION.from_now.to_i,
        iat: Time.current.to_i
      }

      JWT.encode(payload, secret_key, ALGORITHM)
    end

    # Генерация refresh_token
    # @param user [User]
    # @return [String] JWT refresh token
    def generate_refresh_token(user)
      payload = {
        user_id: user.id,
        jti: SecureRandom.uuid,
        exp: REFRESH_EXPIRATION.from_now.to_i,
        iat: Time.current.to_i
      }

      JWT.encode(payload, secret_key, ALGORITHM)
    end

    # Декодирует токен
    # @param token [String]
    # @return [Hash] payload
    # @raise [JWT::DecodeError, JWT::ExpiredSignature]
    def decode(token)
      decoded_token = JWT.decode(token, secret_key, true, algorithm: ALGORITHM)
      decoded_token.first.with_indifferent_access
    rescue JWT::ExpiredSignature
      raise JWT::ExpiredSignature, "Token has expired"
    rescue JWT::DecodeError => e
      raise JWT::DecodeError, "Invalid token: #{e.message}"
    end

    private

    def secret_key
      Rails.application.secret_key_base
    end
  end
end
