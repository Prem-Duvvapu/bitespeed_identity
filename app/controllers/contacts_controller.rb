class ContactsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /identify
  def identify
    email = params[:email]
    phone = params[:phoneNumber]

    contacts = Contact.identify_or_create(email: email, phone: phone)
    render json: format_response(contacts)
  end

  # GET /contacts/:id
  def index
    contacts = Contact.all
    render json: contacts
  end

  # GET /contacts
  def show
    contact = Contact.find_by(id: params[:id])
    if contact
      render json: contact
    else
      render json: { error: "Contact not found" }, status: :not_found
    end
  end

  # DELETE /contacts/:id
  def destroy
    contact = Contact.find_by(id: params[:id])
    if contact
      contact.destroy
      render json: { message: "Contact deleted"}
    else
      render json: { error: "Contact not found"}, status: :not_found
    end
  end

  # DELETE /contacts
  def destroy_all
    Contact.destroy_all
    render json: { message: "All contacts deleted" }
  end


  private

  def format_response(contacts)
    primary = contacts.find(&:primary_linkPrecedence?)
    secondaries = contacts.select(&:secondary_linkPrecedence?)

    {
      contact: {
        primaryContactId: primary.id,
        emails: contacts.map(&:email).compact.uniq,
        phoneNumbers: contacts.map(&:phoneNumber).compact.uniq,
        secondaryContactIds: secondaries.map(&:id)
      }
    }
  end
end
