require 'rails_helper'

RSpec.describe "matchsets/index", type: :view do
  before(:each) do
    assign(:matchsets, [
      Matchset.create!(
        :song_name => "Song Name",
        :picked_player_id => 2,
        :player1_score => 3,
        :player2_score => 4,
        :match_id => 5
      ),
      Matchset.create!(
        :song_name => "Song Name",
        :picked_player_id => 2,
        :player1_score => 3,
        :player2_score => 4,
        :match_id => 5
      )
    ])
  end

  it "renders a list of matchsets" do
    render
    assert_select "tr>td", :text => "Song Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
