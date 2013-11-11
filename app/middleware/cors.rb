module Goliath
  module Contrib
    module Rack
      class CorsAccessControl
        include Goliath::Rack::AsyncMiddleware

        DEFAULT_CORS_HEADERS = {
          'Access-Control-Allow-Origin' => CONFIG['front_root_url'],
          'Access-Control-Allow-Credentials' => 'true',
          'Access-Control-Expose-Headers' => 'X-Error-Message,X-Error-Detail,X-RateLimit-Requests,X-RateLimit-MaxRequests',
          'Access-Control-Max-Age' => '172800',
        }

        DEFAULT_PREFLIGHT_CORS_HEADERS = {
          'Access-Control-Allow-Methods' => 'POST, GET, OPTIONS',
          'Access-Control-Allow-Headers' => 'X-Requested-With,Content-Type'
        }.merge(DEFAULT_CORS_HEADERS)

        def access_control_headers(env)
          cors_headers = DEFAULT_PREFLIGHT_CORS_HEADERS
          client_headers_to_approve = env['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'].to_s.gsub(/[^\w\-\,]+/,'')
          cors_headers['Access-Control-Allow-Headers'] += ",#{client_headers_to_approve}" if not client_headers_to_approve.empty?
          cors_headers
        end

        def call(env, *args)
          if env[Goliath::Request::REQUEST_METHOD] == 'OPTIONS'
            return [200, access_control_headers(env), []]
          end
          super(env)
        end

        def post_process(env, status, headers, body)
          # TODO: github's headers' keys are all upper case, which causes the duplication of cors headers
          [status, DEFAULT_CORS_HEADERS.merge(headers), body]
        end
      end

    end
  end
end
