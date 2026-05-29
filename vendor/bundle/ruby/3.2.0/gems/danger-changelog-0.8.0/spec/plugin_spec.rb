require 'spec_helper'

describe Danger::DangerChangelog do
  subject do
    described_class.new(nil)
  end

  it 'is a Danger plugin' do
    expect(subject).to be_a Danger::Plugin
  end
end
