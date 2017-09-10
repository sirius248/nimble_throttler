module Rack
  class NimbleThrottling
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Request.new(env)

      if SimpleThrottler.endpoints.include?(req.path)
        SimpleThrottler.throttle_for(req)
        if SimpleThrottler.exceed_limit?(req)
          message = "Rate limit exceeded. Try again in #{SimpleThrottler.expires_in(req)} seconds"
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
