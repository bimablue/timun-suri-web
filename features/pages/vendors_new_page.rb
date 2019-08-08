class VendorsNewPage < SitePrism::Page
    include RSpec::Matchers
    set_url "/vendors/new"
    set_url_matcher %r{/vendors/new}

    element :add_vendor_display_name, '#person_display_name'
    element :add_vendor_email, '#person_email'
    element :add_vendor_phone, '#addValue_'
    element :add_vendor_add_field, '#add_new_field'
    element :update_add_vendor_btn, :xpath, "//*[text()='Update Vendor']"
    element :save_add_vendor_detail_btn, '#create_button'
    element :save_vendor_dropdown_btn, "#create_button+button"
    element :save_dropdown_list_create_new_option, :xpath, "//td[contains(text(),'Create & New')]"
    element :save_add_and_new_vendor_detail_btn, "#create_and_new_button"
    element :cancel_btn, :xpath, "//*[@id = 'create_button']/../.."
    element :add_vendor_company_name, '#person_associate_company'
    element :add_vendor_tax_no, '#person_tax_no'
    element :add_vendor_title, '#person_title'
    element :add_vendor_first_name, '#person_first_name'
    element :add_vendor_mobile, '#person_mobile'
    element :add_vendor_phone, '#person_phone'
    element :add_vendor_fax, '#person_fax'
    element :add_vendor_middle_name, '#person_middle_name'
    element :add_vendor_last_name, '#person_last_name'
    element :add_vendor_other, '#person_other_detail'
    element :add_vendor_billing_address, '#person_billing_address'

    def fill_vendor_details(vendor_data)
      add_vendor_email.set vendor_data[:vendor_email]
      add_vendor_company_name.set vendor_data[:display_name]
      add_vendor_tax_no.set vendor_data[:vendor_tax_no]
      add_vendor_title.set vendor_data[:vendor_title]
      add_vendor_first_name.set vendor_data[:vendor_first_name]
      add_vendor_middle_name.set vendor_data[:vendor_middle_name]
      add_vendor_last_name.set vendor_data[:vendor_last_name]
      add_vendor_mobile.set vendor_data[:vendor_mobile]
      add_vendor_phone.set vendor_data[:vendor_phone]
      add_vendor_fax.set vendor_data[:vendor_fax]
      add_vendor_display_name.set vendor_data[:display_name]
      add_vendor_other.set vendor_data[:vendor_other]
      add_vendor_billing_address.set vendor_data[:vendor_billing_address]
    end
end