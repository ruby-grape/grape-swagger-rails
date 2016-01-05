require 'spec_helper'

describe GrapeSwaggerRails do
  context '#options' do
    subject do
      GrapeSwaggerRails.options
    end
    it 'is an instance of Options' do
      expect(subject).to be_a GrapeSwaggerRails::Options
    end
    it 'defaults headers to an empty hash' do
      expect(subject.headers).to eq({})
    end
  end
end
