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

  describe ".get" do
    it "makes the request" do
      VCR.use_cassette("get") do
        described_class.get(id: "76e58f5e75")
      end
    end
  end

  describe ".create" do
    it "makes the request" do
      VCR.use_cassette("create") do
        described_class.create(attributes: {
          name: "Some snitch",
          tags: ["some", "tags"],
          alert_type: "basic",
          interval: "hourly",
          alert_email: ["foo@example.com"],
          notes: "some notes"
        })
      end
    end
  end
end
