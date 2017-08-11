require 'rails_helper'

RSpec.describe "players/edit", type: :view do
  before(:each) do
    @player = assign(:player, Player.create!(
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

  it "renders the edit player form" do
    render

    assert_select "form[action=?][method=?]", player_path(@player), "post" do

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
