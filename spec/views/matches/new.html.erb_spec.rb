require 'rails_helper'

RSpec.describe "matches/new", type: :view do
  before(:each) do
    assign(:match, Match.new(
      :challonge_match_id => 1,
      :tournament_id => 1,
      :player1_id => 1,
      :player2_id => 1,
      :player1_score => 1,
      :player2_score => 1,
      :winner_id => 1
    ))
  end

  it "renders new match form" do
    render

    assert_select "form[action=?][method=?]", matches_path, "post" do

      assert_select "input#match_challonge_match_id[name=?]", "match[challonge_match_id]"

      assert_select "input#match_tournament_id[name=?]", "match[tournament_id]"

      assert_select "input#match_player1_id[name=?]", "match[player1_id]"

      assert_select "input#match_player2_id[name=?]", "match[player2_id]"

      assert_select "input#match_player1_score[name=?]", "match[player1_score]"

      assert_select "input#match_player2_score[name=?]", "match[player2_score]"

      assert_select "input#match_winner_id[name=?]", "match[winner_id]"
    end
  end
end
