$:.unshift(File.dirname(__FILE__) + '/')

require 'initialization'
require 'api/documents'
require 'middleware/cors'

class Application < Goliath::API
  
  use Goliath::Contrib::Rack::CorsAccessControl
  
  def response(env)
    Cocowrite::API::Documents.call(env)
  end

end
