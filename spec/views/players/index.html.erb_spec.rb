require 'rails_helper'

RSpec.describe "players/index", type: :view do
  before(:each) do
    assign(:players, [
      Player.create!(
        :name => "Name",
        :email => "Email",
        :phone => "Phone",
        :challonge_player_id => 2,
        :qualifier_score => 3,
        :seed => 4,
        :place => 5,
        :tournament_id => 6
      ),
      Player.create!(
        :name => "Name",
        :email => "Email",
        :phone => "Phone",
        :challonge_player_id => 2,
        :qualifier_score => 3,
        :seed => 4,
        :place => 5,
        :tournament_id => 6
      )
    ])
  end

  it "renders a list of players" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
  end
end
