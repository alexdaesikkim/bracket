require 'rails_helper'

RSpec.describe "matchsets/show", type: :view do
  before(:each) do
    @matchset = assign(:matchset, Matchset.create!(
      :song_name => "Song Name",
      :picked_player_id => 2,
      :player1_score => 3,
      :player2_score => 4,
      :match_id => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Song Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
  end
end
