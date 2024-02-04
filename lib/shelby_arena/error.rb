module ShelbyArena
  class Error < StandardError; end
  class BadGateway < Error; end
  class BadRequest < Error; end
  class CloudflareError < Error; end
  class Forbidden < Error; end
  class GatewayTimeout < Error; end
  class InternalServerError < Error; end
  class NotFound < Error; end
  class ServiceUnavailable < Error; end
  class Unauthorized < Error; end
end

require 'faraday'
module FaradayMiddleware
  class ShelbyArenaErrorHandler < Faraday::Middleware
    ERROR_STATUSES = 400..600

    def on_complete(env)
      case env[:status]
      when 400
        raise ShelbyArena::BadRequest, error_message(env)
      when 401
        raise ShelbyArena::Unauthorized, error_message(env)
      when 403
        raise ShelbyArena::Forbidden, error_message(env)
      when 404
        raise ShelbyArena::NotFound, error_message(env)
      when 500
        raise ShelbyArena::InternalServerError, error_message(env)
      when 502
        raise ShelbyArena::BadGateway, error_message(env)
      when 503
        raise ShelbyArena::ServiceUnavailable, error_message(env)
      when 504
        raise ShelbyArena::GatewayTimeout, error_message(env)
      when 520
        raise ShelbyArena::CloudflareError, error_message(env)
      when ERROR_STATUSES
        raise ShelbyArena::Error, error_message(env)
      end
    end

    private

    def error_message(env)
      "#{env[:status]}: #{env[:url]} #{env[:body]}"
    end
  end
end
