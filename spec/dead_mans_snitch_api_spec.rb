# frozen_string_literal: true

RSpec.describe DeadMansSnitchApi do
  it "has a version number" do
    expect(DeadMansSnitchApi::GEM_VERSION).to_not be nil
  end

  describe ".all_snitches" do
    it "makes the request" do
      VCR.use_cassette("all_snitches") do
        described_class.all_snitches
      end
    end
  end

  describe ".get_snitch" do
    it "makes the request" do
      VCR.use_cassette("get_snitch") do
        described_class.get_snitch(id: "76e58f5e75")
      end
    end
  end
end
