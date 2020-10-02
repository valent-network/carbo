# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(DemoContactsPopulatorJob) do
  let(:phone_number) { create(:phone_number) }
  let(:demo_phone_number) { create(:phone_number, demo: true) }
  let(:user) { create(:user, phone_number: demo_phone_number) }
  let!(:other_user) { create(:user) }
  let!(:some_contact) { create(:user_contact, user: user, phone_number: phone_number) }

  before do
    create(:demo_phone_number, phone_number: demo_phone_number)
  end

  it 'destroys non-demo contacts' do
    expect { subject.perform }.to(change { UserContact.where(phone_number: phone_number, user: user).count }.from(1).to(0))
  end
  it 'creates demo contacts' do
    expect { subject.perform }.to(change { UserContact.where(phone_number: other_user.phone_number, user: user).count }.from(0).to(1))
  end
end
