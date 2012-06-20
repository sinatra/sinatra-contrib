require 'backports'
require_relative 'spec_helper'

describe Sinatra::ConfigFile do
  def config_file(*args, &block)
    mock_app do
      register Sinatra::ConfigFile
      set :root, File.expand_path('../config_file', __FILE__)
      instance_eval(&block) if block
      config_file(*args)
    end
  end

  it 'should set options from a simple config_file' do
    config_file 'key_value.yml'
    settings.foo.should == 'bar'
    settings.something.should == 42
  end

  it 'should create indifferent hashes' do
    config_file 'key_value.yml'
    settings.nested['a'].should == 1
    settings.nested[:a].should == 1
  end

  it 'should recognize env specific settings per file' do
    config_file 'with_envs.yml'
    settings.foo.should == 'test'
  end

  it 'should recognize env specific settings per setting' do
    config_file 'with_nested_envs.yml'
    settings.database[:adapter].should == 'sqlite'
  end

  it 'should recognize env specific settings per setting when default clause is in use' do
    config_file 'with_nested_default.yml'
    settings.database[:adapter].should == 'sqlite'
  end

  it 'should not set present values to nil if the current env is missing' do
    # first let's check the test is actually working properly
    config_file('missing_env.yml') { set :foo => 42, :environment => :production }
    settings.foo.should == 10
    # now test it
    config_file('missing_env.yml') { set :foo => 42, :environment => :test }
    settings.foo.should == 42
  end

  it 'should set present values if the current env is missing but default clause is here' do
    # first let's check the test is actually working properly
    config_file('missing_env_but_default.yml') { set :foo => 42, :environment => :production }
    settings.foo.should == 10
    # now test it
    config_file('missing_env_but_default.yml') { set :foo => 42, :environment => :test }
    settings.foo.should == 30
  end

  it 'should prioritize settings in latter files' do
    # first let's check the test is actually working properly
    config_file 'key_value.yml'
    settings.foo.should == 'bar'
    # now test it
    config_file 'key_value_override.yml'
    settings.foo.should == 'foo'
  end

  it 'should prioritize settings in latter files respecting defaults' do
    config_file 'key_value.yml', 'key_value_override_default.yml'
    settings.foo.should == 'default-foo'
  end

  it 'should merge defaults' do
    config_file('default_merge.yml')
    settings.foo.should == 'default-foo'
    settings.bar.should == 'bar'
    settings.zoo.should == 'zoo'
  end

  it 'should not merge defaults when it should not' do
    config_file('default_merge.yml') { set :zoo => 42, :environment => :production }
    settings.foo.should == 'default-foo'
    settings.bar.should == 'default-bar'
    settings.zoo.should == 42
  end
end
