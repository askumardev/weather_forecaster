require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ForecastsHelper. For example:
#
# describe ForecastsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ForecastsHelper, type: :helper do
  it 'is available to helper specs' do
    expect(helper.class.ancestors).to include(ForecastsHelper)
  end
end
