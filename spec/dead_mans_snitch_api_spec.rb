# frozen_string_literal: true

RSpec.describe DeadMansSnitchApi do
  it "has a version number" do
    expect(DeadMansSnitchApi::GEM_VERSION).to_not be_nil
  end

  describe ".all_snitches" do
    subject(:all_snitches) { described_class.all_snitches }

    it "returns a array of snitches" do
      VCR.use_cassette("all_snitches") do
        expect(all_snitches).to be_a Array
      end
    end
  end

  describe ".get" do
    subject(:get) { described_class.get(token: "76e58f5e75") }

    it "returns the snitch" do
      VCR.use_cassette("get") do
        expect(get.name).to eq("Test snitch")
      end
    end
  end

  describe ".create" do
    let(:create) { described_class.create(attributes: attributes) }

    context "on success" do
      let(:attributes) do
        {
          name: "Some snitch",
          tags: %w[some tags],
          alert_type: "basic",
          interval: "hourly",
          alert_email: ["foo@example.com"],
          notes: "some notes",
        }
      end

      it "creates the snitch" do
        VCR.use_cassette("create") do
          expect(create.token).to_not be_nil
        end
      end
    end

    context "on failure" do
      let(:attributes) do
        {
          name: "Failed snitch",
        }
      end

      it "returns an error" do
        VCR.use_cassette("create_failed") do
          expect { create }.to raise_error(DeadMansSnitchApi::RequestError)
        end
      end
    end
  end

  describe ".update" do
    subject(:update) do
      described_class.update(token: "7706471376", attributes: attributes)
    end

    context "on success" do
      let(:attributes) do
        {
          name: "New snitch name",
        }
      end

      it "makes the request" do
        VCR.use_cassette("update") do
          expect(update.name).to eq("New snitch name")
        end
      end
    end

    context "on failure" do
      let(:attributes) do
        {
          interval: "30_minute",
        }
      end

      it "makes the request" do
        VCR.use_cassette("update_failed") do
          expect { update }.to raise_error(DeadMansSnitchApi::RequestError)
        end
      end
    end
  end

  describe ".pause" do
    subject(:pause) { described_class.pause(token: "7706471376") }

    it "returns true" do
      VCR.use_cassette("pause") do
        expect(pause).to eq(true)
      end
    end
  end

  describe ".delete" do
    subject(:delete) { described_class.delete(token: "7706471376") }

    it "returns true" do
      VCR.use_cassette("delete") do
        expect(delete).to eq(true)
      end
    end
  end

  describe ".notify" do
    subject(:notify) { described_class.notify(token: "c2d13fbfcf") }

    it "makes the request" do
      VCR.use_cassette("notify") do
        expect(notify).to eq(true)
      end
    end
  end
end
