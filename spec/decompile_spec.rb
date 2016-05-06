require 'spec_helper'

RSpec::Matchers.define :decompile do |path|
  match do |app|
    @compiled, @keys    = app.send :compile, path
    @decompiled         = app.decompile(@compiled, @keys)
    expect(@decompiled).to eq(path)
  end

  failure_message_for_should do |app|
    "expected #{app} to decompile #{@compiled} with #{@keys} to #{path}, but was #{@decompiled}"
  end
end

describe Sinatra::Decompile do
  subject { Sinatra::Application }
  it { is_expected.to decompile('') }
  it { is_expected.to decompile('/') }
  it { is_expected.to decompile('/?') }
  it { is_expected.to decompile('/foo') }
  it { is_expected.to decompile('/:name') }
  it { is_expected.to decompile('/:name?') }
  it { is_expected.to decompile('/:foo/:bar') }
  it { is_expected.to decompile('/page/:id/edit') }
  it { is_expected.to decompile('/hello/*') }
  it { is_expected.to decompile('/*/foo/*') }
  it { is_expected.to decompile('*') }
  it { is_expected.to decompile(':name.:format') }
  it { is_expected.to decompile('a b') }
  it { is_expected.to decompile('a+b') }
  it { is_expected.to decompile(/./) }
  it { is_expected.to decompile(/f(oo)/) }
  it { is_expected.to decompile(/ba+r/) }

  it 'just returns strings' do
    expect(subject.decompile('/foo')).to eq('/foo')
  end

  it 'just decompile simple regexps without keys' do
    expect(subject.decompile(%r{/foo})).to eq('/foo')
  end
end
