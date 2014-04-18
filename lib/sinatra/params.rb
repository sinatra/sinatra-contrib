require 'sinatra/base'

module Sinatra
  module Params
    class InvalidParameter < Exception; end

    def required_params(*keys)
      keys = [*keys].flatten.map(&:to_s) - params.keys
      unless keys.empty?
        raise InvalidParameter, "Missing required parameter(s): #{keys.map(&:inspect).join(', ')}"
      end
    end
  end

  helpers Params
end
