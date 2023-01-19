# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(AdImage) do
  let(:ad) { create(:ad) }
  let(:sample_image_base64) { Base64.strict_encode64(File.read(Rails.root.join('spec/support/sample.png'))) }

  describe '#attachment' do
    it 'successfully consumes base64 image' do
      subject.attachment = "data:image/png;base64,#{sample_image_base64}"
      subject.ad = ad
      subject.position = 0

      expect(subject.save).to(be_truthy)
      expect(subject.attachment.size).to(eq(5138))
    end
  end
end
