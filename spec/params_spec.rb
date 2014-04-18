require_relative 'spec_helper'

describe Sinatra::Params do
  before do
    mock_app do
      helpers Sinatra::Params
      get '/' do
        required_params(:req1, :req2)
      end
    end
  end

  context "#required_params" do
    it 'raise InvalidParameter if required params do not exist' do
      expect { get('/') }.to raise_error(Sinatra::Params::InvalidParameter)
    end
    it 'raise InvalidParameter if required params do not exist partially' do
      expect { get('/', req1: 1) }.to raise_error(Sinatra::Params::InvalidParameter)
    end
    it 'does not raise InvalidParameter if required params exist' do
      expect { get('/', req1: 1, req2: 2) }.not_to raise_error
    end
  end
end
