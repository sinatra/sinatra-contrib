require 'spec_helper'

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
    expect(settings.foo).to eq('bar')
    expect(settings.something).to eq(42)
  end

  it 'should create indifferent hashes' do
    config_file 'key_value.yml'
    expect(settings.nested['a']).to eq(1)
    expect(settings.nested[:a]).to eq(1)
  end

  it 'should render options in ERB tags' do
    config_file 'key_value.yml.erb'
    expect(settings.foo).to eq('bar')
    expect(settings.something).to eq(42)
    expect(settings.nested['a']).to eq(1)
    expect(settings.nested[:a]).to eq(1)
    expect(settings.nested['b']).to eq(2)
    expect(settings.nested[:b]).to eq(2)
  end

  it 'should recognize env specific settings per file' do
    config_file 'with_envs.yml'
    expect(settings.foo).to eq('test')
  end

  it 'should recognize env specific settings per setting' do
    config_file 'with_nested_envs.yml'
    expect(settings.database[:adapter]).to eq('sqlite')
  end

  it 'should not set present values to nil if the current env is missing' do
    # first let's check the test is actually working properly
    config_file('missing_env.yml') { set foo: 42, environment: :production }
    expect(settings.foo).to eq(10)
    # now test it
    config_file('missing_env.yml') { set foo: 42, environment: :test }
    expect(settings.foo).to eq(42)
  end

  it 'should prioritize settings in latter files' do
    # first let's check the test is actually working properly
    config_file 'key_value.yml'
    expect(settings.foo).to eq('bar')
    # now test it
    config_file 'key_value_override.yml'
    expect(settings.foo).to eq('foo')
  end
end
