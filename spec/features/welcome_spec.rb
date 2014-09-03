require 'spec_helper'

describe 'Welcome' do
  before do
    visit '/'
  end
  it 'renders a link to swagger' do
    expect(page).to have_css 'a[href="/swagger"]'
  end
end
