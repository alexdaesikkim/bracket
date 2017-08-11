require 'rails_helper'

RSpec.describe "picks/show", type: :view do
  before(:each) do
    @pick = assign(:pick, Pick.create!(
      :player_id => 2,
      :song_name => "Song Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Song Name/)
  end
end
