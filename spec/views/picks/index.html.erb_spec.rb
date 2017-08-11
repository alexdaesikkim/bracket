require 'rails_helper'

RSpec.describe "picks/index", type: :view do
  before(:each) do
    assign(:picks, [
      Pick.create!(
        :player_id => 2,
        :song_name => "Song Name"
      ),
      Pick.create!(
        :player_id => 2,
        :song_name => "Song Name"
      )
    ])
  end

  it "renders a list of picks" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Song Name".to_s, :count => 2
  end
end
