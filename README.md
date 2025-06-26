# 🧠 Bitespeed Backend Task: Identity Reconciliation

This is the backend implementation for the [Bitespeed Identity Reconciliation Task](https://bitespeed.notion.site/Bitespeed-Backend-Task-Identity-Reconciliation-1fb21bb2a930802eb896d4409460375c) — built to identify and consolidate user identities across multiple purchases based on contact details (email and/or phone number).

Live API: **https://bitespeed-backend-task-identity-wubg.onrender.com**

---

## 🚀 Tech Stack

- **Backend**: Ruby on Rails (v8)
- **Database**: MySQL
- **Hosting**: Render.com for application and Aiven for MySQL DB

---

## 📁 Project Structure

| File/Folder                            | Purpose                                            |
|----------------------------------------|----------------------------------------------------|
| `app/controllers/contacts_controller.rb` | Contains the `/identify` endpoint and contact APIs |
| `app/models/contact.rb`               | Core business logic for identity reconciliation    |
| `config/routes.rb`                    | API endpoint routing configuration                 |
| `db/schema.rb`                        | Auto-generated DB schema after migrations          |
| `config/database.yml`                 | Database connection config (for dev/test/prod)     |

---

## 📦 Setup Instructions

### 1. Clone the Repository

`git clone https://github.com/your-username/bitespeed-identity.git`  
`cd bitespeed-identity`

### 2. Install Dependencies

`bundle install`

### 3. Configure the Database

Update the `config/database.yml` file with your local or remote MySQL credentials.

### 4. Setup the Database

`rails db:create`  
`rails db:migrate`

### 5. Run the Server

`rails server`

---

## 📮 API Endpoints

### `POST /identify`

Identifies and consolidates a user contact.

#### Sample Request

```json
{
  "email": "example@email.com",
  "phoneNumber": "1234567890"
}
```

#### Sample Response

```json
{
  "contact": {
    "primaryContatctId": 1,
    "emails": ["example@email.com", "alt@email.com"],
    "phoneNumbers": ["1234567890"],
    "secondaryContactIds": [2, 3]
  }
}
```

## 🔧 Additional API Endpoints

These endpoints allow you to view and manage contact records.

### GET /contacts  
**Description:** Retrieve all contact records.  
**Response:** Returns a list of all contacts.

### GET /contacts/:id  
**Description:** Retrieve a single contact by its unique ID.  
**Response:** Returns the contact details if found.

### DELETE /contacts/:id  
**Description:** Permanently delete a contact by its ID.  
**Response:** Returns a success message if deletion was successful.

### DELETE /contacts  
**Description:** Permanently delete all contact records.  
**Response:** Returns a confirmation message after clearing all data.
