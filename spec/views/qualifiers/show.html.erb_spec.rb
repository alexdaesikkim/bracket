require 'rails_helper'

RSpec.describe "qualifiers/show", type: :view do
  before(:each) do
    @qualifier = assign(:qualifier, Qualifier.create!(
      :name => "Name",
      :number => 2,
      :tiebreaker => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
  end
end
