require 'spec_helper'

describe Danger::Changelog::ChangelogPlaceholderLine do
  let(:config) { Danger::Changelog.config }

  context 'with a custom placeholder line' do
    before do
      config.placeholder_line = "* Nothing yet here.\n"
    end

    context 'when line is equal to placeholder_line from config' do
      it_behaves_like 'validates as changelog placeholder line', "* Nothing yet here.\n"
      it_behaves_like 'valid changelog placeholder line', "* Nothing yet here.\n"
    end

    context 'when line is not equal to placeholder_line from config' do
      it_behaves_like 'does not validate as changelog placeholder line', "* Put your contribution here.\n"
      it_behaves_like 'invalid changelog placeholder line', "* Put your contribution here.\n"
    end
  end

  context 'with a blank placeholder line' do
    before do
      config.placeholder_line = nil
    end

    context 'when line is not blank' do
      it_behaves_like 'does not validate as changelog placeholder line', "* Whatever.\n"
      it_behaves_like 'invalid changelog placeholder line', "* Whatever.\n"
    end
  end
end
