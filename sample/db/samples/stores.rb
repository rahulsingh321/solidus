# frozen_string_literal: true
united_states = Spree::Country.find_by!(iso: "US")
new_york = Spree::State.find_by!(name: "New York")

unless Spree::Store.where(code: 'sample-store').exists?
  Spree::Store.create!(
    name: "Sample Store",
    code: "sample-store",
    url: "example.com",
    mail_from_address: "store@example.com",
    legal_name: "Sample Store LLC",
    contact_email: "sample@mail.co",
    contact_phone: "9876543210",
    description: "This is Sample Store",
    vat_id: "VAT12345",
    tax_id: "TAX98765",
    address1: "123 Sample Street",
    address2: "Suite 456",
    city: "Sample City",
    zipcode: 12345,
    country: united_states,
    state: new_york,
  )
end
