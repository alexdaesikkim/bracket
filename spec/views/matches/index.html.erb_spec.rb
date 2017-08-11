require 'rails_helper'

RSpec.describe "matches/index", type: :view do
  before(:each) do
    assign(:matches, [
      Match.create!(
        :challonge_match_id => 2,
        :tournament_id => 3,
        :player1_id => 4,
        :player2_id => 5,
        :player1_score => 6,
        :player2_score => 7,
        :winner_id => 8
      ),
      Match.create!(
        :challonge_match_id => 2,
        :tournament_id => 3,
        :player1_id => 4,
        :player2_id => 5,
        :player1_score => 6,
        :player2_score => 7,
        :winner_id => 8
      )
    ])
  end

  it "renders a list of matches" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
  end
end
