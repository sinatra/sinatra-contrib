require_relative 'spec_helper'
load File.join(Dir.getwd, "generator.thor")

describe Sinatra::Generator do

  describe "#generate" do

    it "copies all template files to target directory" do
      app_name = "my-app"
      target = "target_directory"

      @action = Sinatra::Generator.new([app_name, target])

      expect(@action).to receive(:template).once.with("#{Dir.getwd}/template/README.md", "#{target}/#{app_name}/README.md", {:force=>true})
      expect(@action).to receive(:template).once.with( "#{Dir.getwd}/template/template.rb", "#{target}/#{app_name}/my_app.rb", {:force=>true})
      expect(@action).to receive(:template).once.with( "#{Dir.getwd}/template/Rakefile", "#{target}/#{app_name}/Rakefile", {:force=>true})
      expect(@action).to receive(:template).once.with( "#{Dir.getwd}/template/config.ru", "#{target}/#{app_name}/config.ru", {:force=>true})
      expect(@action).to receive(:template).once.with( "#{Dir.getwd}/template/Gemfile", "#{target}/#{app_name}/Gemfile", {:force=>true})
      expect(@action).to receive(:template).once.with( "#{Dir.getwd}/template/.ruby-gemset", "#{target}/#{app_name}/.ruby-gemset", {:force=>true})
      expect(@action).to receive(:template).once.with( "#{Dir.getwd}/template/spec/template_spec.rb", "#{target}/#{app_name}/spec/my_app_spec.rb", {:force=>true})
      expect(@action).to receive(:template).once.with( "#{Dir.getwd}/template/spec/spec_helper.rb", "#{target}/#{app_name}/spec/spec_helper.rb", {:force=>true})
      expect(@action).to receive(:template).once.with( "#{Dir.getwd}/template/.ruby-version", "#{target}/#{app_name}/.ruby-version", {:force=>true})

      @action.generate
    end

  end
end