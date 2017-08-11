require 'rails_helper'

RSpec.describe "tournaments/new", type: :view do
  before(:each) do
    assign(:tournament, Tournament.new(
      :name => "MyString",
      :challonge_tournament_id => 1,
      :game_id => 1,
      :main_stage => false,
      :qualifier_stage => false
    ))
  end

  it "renders new tournament form" do
    render

    assert_select "form[action=?][method=?]", tournaments_path, "post" do

      assert_select "input#tournament_name[name=?]", "tournament[name]"

      assert_select "input#tournament_challonge_tournament_id[name=?]", "tournament[challonge_tournament_id]"

      assert_select "input#tournament_game_id[name=?]", "tournament[game_id]"

      assert_select "input#tournament_main_stage[name=?]", "tournament[main_stage]"

      assert_select "input#tournament_qualifier_stage[name=?]", "tournament[qualifier_stage]"
    end
  end
end
