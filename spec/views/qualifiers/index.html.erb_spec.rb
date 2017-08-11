require 'rails_helper'

RSpec.describe "qualifiers/index", type: :view do
  before(:each) do
    assign(:qualifiers, [
      Qualifier.create!(
        :name => "Name",
        :number => 2,
        :tiebreaker => false
      ),
      Qualifier.create!(
        :name => "Name",
        :number => 2,
        :tiebreaker => false
      )
    ])
  end

  it "renders a list of qualifiers" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
