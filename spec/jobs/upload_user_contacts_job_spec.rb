# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(UploadUserContactsJob) do
  let(:user) { create(:user) }

  it 'works' do
    user_contacts = [{ 'phoneNumbers' => ['+380931234567'], 'name' => 'Alice' }].to_json
    expect { subject.perform(user.id, user_contacts) }.to(change { UserContact.count }.from(0).to(1))
  end

  it 'truncates long names' do
    user_contacts = [{ 'phoneNumbers' => ['+380931234567'], 'name' => 'Alice' * 100 }].to_json
    expect { subject.perform(user.id, user_contacts) }.to(change { UserContact.count }.from(0).to(1))
    phone_number = PhoneNumber.where(full_number: '931234567').first
    expect(UserContact.where(phone_number: phone_number).first.name.length).to(eq(100))
  end
end
