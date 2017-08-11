require 'rails_helper'

RSpec.describe "tournaments/index", type: :view do
  before(:each) do
    assign(:tournaments, [
      Tournament.create!(
        :name => "Name",
        :challonge_tournament_id => 2,
        :game_id => 3,
        :main_stage => false,
        :qualifier_stage => false
      ),
      Tournament.create!(
        :name => "Name",
        :challonge_tournament_id => 2,
        :game_id => 3,
        :main_stage => false,
        :qualifier_stage => false
      )
    ])
  end

  it "renders a list of tournaments" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
