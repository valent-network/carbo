# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(UploadUserContactsJob) do
  let(:user) { create(:user) }
  let(:no_valid_numbers_contacts) do
    '[{"name":"Kate Bell Creative Consulting","phoneNumbers":["(555) 564-8583","(415) 555-3695"]},{"name":"Daniel Higgins","phoneNumbers":["555-478-7672","(408) 555-5270","(408) 555-3514"]},{"name":"John Appleseed","phoneNumbers":["888-555-5512","888-555-1212"]},{"name":"Anna Haro","phoneNumbers":["555-522-8243"]},{"name":"Hank M. Zakroff Financial Services Inc.","phoneNumbers":["(555) 766-4823","(707) 555-1854"]},{"name":"David Taylor","phoneNumbers":["555-610-6679"]}]'
  end

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

  it 'does not create records for invalid numbers' do
    expect { subject.perform(user.id, no_valid_numbers_contacts) }.to_not(change { UserContact.count })
  end
end
