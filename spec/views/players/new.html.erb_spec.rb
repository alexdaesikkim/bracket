require 'rails_helper'

RSpec.describe "players/new", type: :view do
  before(:each) do
    assign(:player, Player.new(
      :name => "MyString",
      :email => "MyString",
      :phone => "MyString",
      :challonge_player_id => 1,
      :qualifier_score => 1,
      :seed => 1,
      :place => 1,
      :tournament_id => 1
    ))
  end

  it "renders new player form" do
    render

    assert_select "form[action=?][method=?]", players_path, "post" do

      assert_select "input#player_name[name=?]", "player[name]"

      assert_select "input#player_email[name=?]", "player[email]"

      assert_select "input#player_phone[name=?]", "player[phone]"

      assert_select "input#player_challonge_player_id[name=?]", "player[challonge_player_id]"

      assert_select "input#player_qualifier_score[name=?]", "player[qualifier_score]"

      assert_select "input#player_seed[name=?]", "player[seed]"

      assert_select "input#player_place[name=?]", "player[place]"

      assert_select "input#player_tournament_id[name=?]", "player[tournament_id]"
    end
  end
end
