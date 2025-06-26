class ContactsController < ApplicationController
  def identify
    email = params[:email]
    phone = params[:phoneNumber]

    contacts = Contact.identify_or_create(email: email, phone: phone)
    render json: format_response(contacts)
  end

  private

  def format_response(contacts)
    primary = contacts.find(&:primary?)
    secondaries = contacts.select(&:secondary?)

    {
      contact: {
        primaryContactId: primary.id;
        emails: contacts.map(&:email).compact.uniq,
        phoneNumbers: contacts.map(&:phoneNumber).compact.uniq,
        secondaryContactIds: secondaries.map(&:id)
      }
    }
end
