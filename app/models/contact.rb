class Contact < ApplicationRecord
  enum :linkPrecedence, { primary: "primary", secondary: "secondary" }, suffix: true

  def self.identify_or_create(email:, phone:)
    matching_contacts = find_matching_contacts(email, phone)

    if matching_contacts.empty?
      return [create_primary(email,phone)]
    end

    all_contacts = fetch_all_linked_contacts(matching_contacts)
    primary_contact = resolve_primary_contact(all_contacts)

    create_secondary_if_needed(email, phone, all_contacts, primary_contact)

    fetch_all_linked_contacts([primary_contact])
  end


  def self.find_matching_contacts(email, phone)
    Contact.where("email = ? OR phoneNumber = ?", email, phone)
  end


  def self.create_primary(email, phone)
    Contact.create!(email: email, phoneNumber: phone, linkPrecedence: :primary)
  end


  def self.fetch_all_linked_contacts(contacts)
    ids = contacts.map(&:id) + contacts.map(&:linkedId).compact
    Contact.where("id IN (?) OR linkedId IN (?)", ids, ids)
  end

  def self.resolve_primary_contact(contacts)
    primaries = contacts.select(&:primary_linkPrecedence?)
    primary = primaries.min_by(&:created_at)

    (primaries - [primary]).each do |c|
      c.update!(linkPrecedence: :secondary, linkedId: primary.id)
    end

    primary
  end

  def self.create_secondary_if_needed(email, phone, contacts, primary_contact)
    existing_emails = contacts.map(&:email).compact.uniq
    existing_phones = contacts.map(&:phoneNumber).compact.uniq

    need_new_contact = (email.present? && !existing_emails.include?(email)) || (phone.present? && !existing_phones.include?(phone))
    return unless need_new_contact

    Contact.create!(
      email: email,
      phoneNumber: phone,
      linkPrecedence: :secondary,
      linkedId: primary_contact.id
    )
  end
end
