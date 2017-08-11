require 'rails_helper'

RSpec.describe "qualifiers/edit", type: :view do
  before(:each) do
    @qualifier = assign(:qualifier, Qualifier.create!(
      :name => "MyString",
      :number => 1,
      :tiebreaker => false
    ))
  end

  it "renders the edit qualifier form" do
    render

    assert_select "form[action=?][method=?]", qualifier_path(@qualifier), "post" do

      assert_select "input#qualifier_name[name=?]", "qualifier[name]"

      assert_select "input#qualifier_number[name=?]", "qualifier[number]"

      assert_select "input#qualifier_tiebreaker[name=?]", "qualifier[tiebreaker]"
    end
  end
end
