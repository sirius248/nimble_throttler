module Rack
  class NimbleThrottling
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Request.new(env)

      if NimbleThrottler.endpoints.include?(req.path)
        NimbleThrottler.throttle_for(req)
        if NimbleThrottler.exceed_limit?(req)
          message = "Rate limit exceeded. Try again in #{NimbleThrottler.expires_in(req)} seconds"
          [429, { 'Content-Type' => 'text/html', 'Content-Length' => message.size.to_s }, [message]]
        else
          normal_response(env)
        end
      else
        normal_response(env)
      end
    end

    def normal_response(env)
      status, headers, body = @app.call(env)
      [status, headers, body]
    end
  end
end
