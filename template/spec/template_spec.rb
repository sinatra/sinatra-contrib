require File.expand_path '../spec_helper.rb', __FILE__

describe "Home page" do

  it 'has an index page' do
    get '/'

    expect(last_response.status).to eql 200
    expect(last_response.body).to eql "<%= @project_name_camelised %> home page"
  end

end