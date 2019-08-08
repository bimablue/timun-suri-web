class VendorsDetailPage < SitePrism::Page
    include RSpec::Matchers
    set_url_matcher %r{/.*/vendors/detail/.*}

    element :edit_vendor_btn, :xpath, "//*[contains(@href, '/vendors/edit')]"
    element :vendor_name, :xpath, '(//dd[@class="break-word"])[1]'
    element :actions_btn, :xpath, "//button[contains(.,'Actions')]"
    element :vendor_contact, :xpath, "(//dd[@class='break-word'])[2]"
    element :vendor_email, :xpath, "(//dd[@class='break-word'])[3]"
    element :vendor_mobile, :xpath, "(//dd[@class='break-word'])[4]"
    element :vendor_billing_address, :xpath, "(//dd[@class='break-word'])[5]"
    element :vendor_phone, :xpath, "(//dd[@class='break-word'])[6]"
    element :vendor_fax, :xpath, "(//dd[@class='break-word'])[7]"
    element :vendor_other, :xpath, "(//dd[@class='break-word'])[8]"

    def verify_new_vendor_details(created_vendor)
      expect(vendor_email.text).to eq created_vendor[:vendor_email]
      expect(vendor_name.text).to eq created_vendor[:display_name]
      expect(vendor_mobile.text).to eq created_vendor[:vendor_mobile]
      expect(vendor_phone.text).to eq created_vendor[:vendor_phone]
      expect(vendor_fax.text).to eq created_vendor[:vendor_fax]
      expect(vendor_contact.text).to eq created_vendor[:vendor_title] + " " + created_vendor[:vendor_first_name] + " " + created_vendor[:vendor_middle_name] + " " + created_vendor[:vendor_last_name]
      expect(vendor_other.text).to eq created_vendor[:vendor_other]
      expect(vendor_billing_address.text).to eq created_vendor[:vendor_billing_address]
    end
end