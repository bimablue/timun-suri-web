require_relative "../sections/top_menu_section.rb"

class PurchasesNewPage < SitePrism::Page
  include RSpec::Matchers
  include GeneratorFaker
  include BaseHelper
  set_url "/purchases/new"

  element :create_purchase_header, '#purchase-header'
  element :purchase_type_dropdown, '#s2id_selected_type'
  element :select_vendor_dropdown, '#select2-chosen-13'
  element :add_vendor, :xpath, "(//a[text()='+ Type to Add'] | //div[text()='+ Type to Add'])[1]"
  element :add_vendor_name, '#person_display_name'
  element :add_vendor_email, '#person_email'
  element :add_vendor_bill_address, '#person_billing_address'
  element :add_vendor_phone, '#addValue_'
  element :add_vendor_add_field, '#add_new_field'
  element :add_vendor_show_detail, '#show_full_detail'
  element :save_add_vendor_btn, '#add-new-vendor'
  element :email_field, '#transaction_email'
  element :save_add_vendor_detail_btn, '#add-new-vendor-detail'
  element :close_btn, :xpath, "//button[@id = 'add-new-vendor']/preceding-sibling::*"
  element :add_vendor_company_name, '#person_detail_associate_company'
  element :add_vendor_detail_email, '#person_detail_email'
  element :add_vendor_detail_tax, '#person_detail_tax_no'
  element :add_vendor_detail_title, '#person_detail_title'
  element :add_vendor_detail_first_name, '#person_detail_first_name'
  element :add_vendor_detail_mobile, '#person_detail_mobile'
  element :add_vendor_detail_phone, '#person_detail_phone'
  element :add_vendor_detail_fax, '#person_detail_fax'
  element :add_vendor_detail_middle_name, '#person_detail_middle_name'
  element :add_vendor_detail_last_name, '#person_detail_last_name'
  element :add_vendor_detail_other, '#person_detail_other_detail'
  element :add_vendor_detail_display_name, '#person_detail_display_name'
  element :add_vendor_detail_billing_address, '#person_detail_billing_address'
  section :top_menu, TopMenuSection, "nav[class='navbar sm top-navbar']"
  @@register_account_title="css:#modal-label"

  def create_new_vendor(type)
    vendor_details = faker_vendor_page_new
    unless (select_dropdown select_vendor_dropdown, vendor_details[:display_name]) & !(element_displayed? @@register_account_title)
      add_vendor.click
      if type.downcase == "simple"
        wait_until_add_vendor_name_visible 30
        custom_fill(add_vendor_name, vendor_details[:display_name])
        p "User set vendor name as #{vendor_details[:display_name]}"
        custom_fill(add_vendor_email, vendor_details[:vendor_email])
        p "User set vendor email as #{vendor_details[:vendor_email]}"
        add_vendor_bill_address.set vendor_details[:vendor_billing_address]
        p "User set vendor bill address as #{vendor_details[:vendor_billing_address]}"
        add_vendor_phone.set vendor_details[:vendor_phone]
        p "User set vendor phone as #{vendor_details[:vendor_phone]}"
        save_add_vendor_btn.click
      else
        wait_until_add_vendor_show_detail_visible 30
        add_vendor_show_detail.click
        wait_until_add_vendor_detail_display_name_visible 30
        add_vendor_detail_display_name.set vendor_details[:display_name]
        p "User set display name as #{vendor_details[:display_name]}"
        add_vendor_detail_email.set vendor_details[:vendor_email]
        p "User set email as #{vendor_details[:vendor_email]}"
        add_vendor_detail_billing_address.set vendor_details[:vendor_billing_address]
        p "User set billing address as #{vendor_details[:vendor_billing_address]}"
        add_vendor_detail_phone.set vendor_details[:vendor_phone]
        p "User set phone as #{vendor_details[:vendor_phone]}"
        add_vendor_company_name.set vendor_details[:display_name]
        p "User set company name as #{vendor_details[:display_name]}"
        add_vendor_detail_tax.set vendor_details[:display_name]
        p "User set tax no as #{vendor_details[:display_name]}"
        add_vendor_detail_title.set vendor_details[:display_name]
        p "User set title as #{vendor_details[:display_name]}"
        add_vendor_detail_fax.set vendor_details[:display_name]
        p "User set display name as #{vendor_details[:display_name]}"
        add_vendor_detail_first_name.set vendor_details[:vendor_first_name]
        p "User set display name as #{vendor_details[:vendor_first_name]}"
        add_vendor_detail_middle_name.set vendor_details[:vendor_middle_name]
        p "User set display name as #{vendor_details[:vendor_middle_name]}"
        add_vendor_detail_mobile.set vendor_details[:vendor_mobile]
        p "User set display name as #{vendor_details[:vendor_mobile]}"
        add_vendor_detail_last_name.set vendor_details[:vendor_last_name]
        p "User set display name as #{vendor_details[:vendor_last_name]}"
        add_vendor_detail_other.set vendor_details[:vendor_mobile]
        p "User set display name as #{vendor_details[:vendor_mobile]}"
        save_add_vendor_detail_btn.click
        p "Success create new vendor #{vendor_details[:display_name]}"
      end
    end
    select_vendor_dropdown.should have_content(vendor_details[:display_name] + " (vendor)")
  end
end
