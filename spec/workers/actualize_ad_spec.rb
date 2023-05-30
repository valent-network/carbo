# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ActualizeAd) do
  let(:ad1) { create(:ad, :active) }
  let(:ad2) { create(:ad, :active) }

  before do
    create(:user_contact, phone_number: ad1.phone_number)
    create(:user_contact, phone_number: ad2.phone_number)
  end

  describe "#perform" do
    it "enqueues active known Ads to be actualized" do
      expect(Ad.active.known.count).to eq(2)
      expect(Sidekiq::Client).to receive(:push).with(hash_including("args" => [ad1.address])).once
      expect(Sidekiq::Client).to receive(:push).with(hash_including("args" => [ad2.address])).once
      expect(REDIS).to receive(:set).with("actualized:#{ad1.id}", 1).once
      expect(REDIS).to receive(:set).with("actualized:#{ad2.id}", 1).once
      expect(REDIS).to receive(:expire).with("actualized:#{ad1.id}", ActualizeAd::INTERVAL).once
      expect(REDIS).to receive(:expire).with("actualized:#{ad2.id}", ActualizeAd::INTERVAL).once
      subject.perform
    end
    context "with some Ads already recently actualized" do
      it "doesn't enqueue them do" do
        expect(Ad.active.known.count).to eq(2)
        REDIS.set("actualized:#{ad1.id}", 1)
        expect(Sidekiq::Client).to receive(:push).with(hash_including("args" => [ad2.address])).once
        expect(REDIS).to receive(:set).with("actualized:#{ad2.id}", 1).once
        expect(REDIS).to receive(:expire).with("actualized:#{ad2.id}", ActualizeAd::INTERVAL).once
        subject.perform
      end
    end
    context "with all Ads already recently actualized" do
      it "enqueues nothing" do
        expect(Ad.active.known.count).to eq(2)
        REDIS.set("actualized:#{ad1.id}", 1)
        REDIS.set("actualized:#{ad2.id}", 1)
        expect(Sidekiq::Client).to_not receive(:push)
        expect(REDIS).to_not receive(:set)
        expect(REDIS).to_not receive(:expire)
        subject.perform
      end
    end
  end
end
