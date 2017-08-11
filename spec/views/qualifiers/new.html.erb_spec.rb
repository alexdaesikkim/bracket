require 'rails_helper'

RSpec.describe "qualifiers/new", type: :view do
  before(:each) do
    assign(:qualifier, Qualifier.new(
      :name => "MyString",
      :number => 1,
      :tiebreaker => false
    ))
  end

  it "renders new qualifier form" do
    render

    assert_select "form[action=?][method=?]", qualifiers_path, "post" do

      assert_select "input#qualifier_name[name=?]", "qualifier[name]"

      assert_select "input#qualifier_number[name=?]", "qualifier[number]"

      assert_select "input#qualifier_tiebreaker[name=?]", "qualifier[tiebreaker]"
    end
  end
end
