require 'rails_helper'

RSpec.describe "matchsets/new", type: :view do
  before(:each) do
    assign(:matchset, Matchset.new(
      :song_name => "MyString",
      :picked_player_id => 1,
      :player1_score => 1,
      :player2_score => 1,
      :match_id => 1
    ))
  end

  it "renders new matchset form" do
    render

    assert_select "form[action=?][method=?]", matchsets_path, "post" do

      assert_select "input#matchset_song_name[name=?]", "matchset[song_name]"

      assert_select "input#matchset_picked_player_id[name=?]", "matchset[picked_player_id]"

      assert_select "input#matchset_player1_score[name=?]", "matchset[player1_score]"

      assert_select "input#matchset_player2_score[name=?]", "matchset[player2_score]"

      assert_select "input#matchset_match_id[name=?]", "matchset[match_id]"
    end
  end
end
