require 'rack'
require 'logger'
module Goldencobra
  class HandleInvalidPercentEncoding
    DEFAULT_CONTENT_TYPE = 'text/html'
    DEFAULT_CHARSET      = 'utf-8'

    attr_reader :logger
    def initialize(app, stdout=STDOUT)
      @app = app
      @logger = defined?(Rails.logger) ? Rails.logger : Logger.new(stdout)
    end

    def call(env)
      begin
        # calling env.dup here prevents bad things from happening
        request = Rack::Request.new(env.dup)
        # calling request.params is sufficient to trigger the error
        # see https://github.com/rack/rack/issues/337#issuecomment-46453404
        request.params
        @app.call(env)
      rescue ArgumentError => e
        raise unless e.message =~ /invalid %-encoding/
        message = "BAD REQUEST: Returning 400 due to #{e.message} from request with env #{request.inspect}"
        logger.info message
        content_type = env['HTTP_ACCEPT'] || DEFAULT_CONTENT_TYPE
        status = 400
        body   = "Bad Request"
        return [
          status,
          {
            'Content-Type' => "#{content_type}; charset=#{DEFAULT_CHARSET}",
            'Content-Length' => body.bytesize.to_s
          },
          [body]
        ]
      end
    end
  end
end
