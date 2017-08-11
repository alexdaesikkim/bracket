require 'rails_helper'

RSpec.describe "picks/edit", type: :view do
  before(:each) do
    @pick = assign(:pick, Pick.create!(
      :player_id => 1,
      :song_name => "MyString"
    ))
  end

  it "renders the edit pick form" do
    render

    assert_select "form[action=?][method=?]", pick_path(@pick), "post" do

      assert_select "input#pick_player_id[name=?]", "pick[player_id]"

      assert_select "input#pick_song_name[name=?]", "pick[song_name]"
    end
  end
end
