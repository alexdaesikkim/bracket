require 'rails_helper'

RSpec.describe "picks/new", type: :view do
  before(:each) do
    assign(:pick, Pick.new(
      :player_id => 1,
      :song_name => "MyString"
    ))
  end

  it "renders new pick form" do
    render

    assert_select "form[action=?][method=?]", picks_path, "post" do

      assert_select "input#pick_player_id[name=?]", "pick[player_id]"

      assert_select "input#pick_song_name[name=?]", "pick[song_name]"
    end
  end
end
