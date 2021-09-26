# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(UploadUserContactsJob) do
  let(:user) { create(:user) }
  let(:no_valid_numbers_contacts) do
    '[{"name":"Kate Bell Creative Consulting","phoneNumbers":["(555) 564-8583","(415) 555-3695"]},{"name":"Daniel Higgins","phoneNumbers":["555-478-7672","(408) 555-5270","(408) 555-3514"]},{"name":"John Appleseed","phoneNumbers":["888-555-5512","888-555-1212"]},{"name":"Anna Haro","phoneNumbers":["555-522-8243"]},{"name":"Hank M. Zakroff Financial Services Inc.","phoneNumbers":["(555) 766-4823","(707) 555-1854"]},{"name":"David Taylor","phoneNumbers":["555-610-6679"]}]'
  end

  it 'works' do
    user_contacts = [{ 'phoneNumbers' => ['+380931234567'], 'name' => 'Alice' }].to_json
    allow_any_instance_of(User).to(receive(:update_connections!).and_return(nil))
    expect { subject.perform(user.id, user_contacts) }.to(change(UserContact, :count).from(0).to(1))
  end

  it 'ignores semi-invalid numbers (non-9-digits)' do
    user_contacts = [{ 'phoneNumbers' => ['08005010150'], 'name' => 'Universal' }].to_json
    expect { subject.perform(user.id, user_contacts) }.not_to(change(UserContact, :count))
  end

  it 'truncates long names' do
    user_contacts = [{ 'phoneNumbers' => ['+380931234567'], 'name' => 'Alice' * 100 }].to_json
    allow_any_instance_of(User).to(receive(:update_connections!).and_return(nil))
    expect { subject.perform(user.id, user_contacts) }.to(change(UserContact, :count).from(0).to(1))
    phone_number = PhoneNumber.where(full_number: '931234567').first
    expect(UserContact.where(phone_number: phone_number).first.name.length).to(eq(100))
  end

  it 'does not create records for invalid numbers' do
    expect { subject.perform(user.id, no_valid_numbers_contacts) }.not_to(change(UserContact, :count))
  end

  it 'changes existing contacts names' do
    user_contact = create(:user_contact, user: user)
    new_user_contacts = [{ 'phoneNumbers' => [user_contact.phone_number.to_s], name: 'New Name' }].to_json
    allow_any_instance_of(User).to(receive(:update_connections!).and_return(nil))
    expect { subject.perform(user.id, new_user_contacts) }.to(change { user_contact.reload.name }.from(user_contact.name).to('New Name'))
  end

  it 'works for duplicate numbers' do
    user_contacts = [
      { 'phoneNumbers' => ['+380931234567'], 'name' => 'Alice' },
      { 'phoneNumbers' => ['+380931234567'], 'name' => 'Bob' },
    ].to_json
    allow_any_instance_of(User).to(receive(:update_connections!).and_return(nil))
    expect { subject.perform(user.id, user_contacts) }.to(change(UserContact, :count).from(0).to(1))
  end

  it 'does not process invalid phone numbers' do
    invalid_phone_number = '1022240504'
    user_id = user.id
    user_contacts = [
      { 'phoneNumbers' => [invalid_phone_number], 'name' => 'Alice' },
    ].to_json

    expect { subject.perform(user_id, user_contacts) }.not_to(change(PhoneNumber, :count))
  end
end
