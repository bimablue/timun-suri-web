class VendorsIndexPage < SitePrism::Page
    include RSpec::Matchers
    include BaseHelper
    set_url "/vendors/index"
    set_url_matcher %r{/vendors/index}

    element :email_field, '#transaction_email'
    element :add_vendor_btn, :xpath, "//*[@href='/vendors/new']"
    element :first_vendor_table_display_name, :xpath, "(//*[@class='table-header']/following-sibling::*/tr//*[@href])[1]"
    element :check_all, "#check_all"
    element :bulk_delete_btn, "#bulk-delete-button"
    element :confirm_delete_btn, :xpath, "//*[text()='yes']"
    element :ok_btn, :xpath, "//*[text()='OK']"
    element :back_btn, :xpath, "//*[text()='back']"
    element :first_check_box, :xpath, "(//*[@id='person_'])[1]"
    element :search, "#q_display_name_or_billing_address_or_email_cont"

    def list_vendor_displayed?
      first_vendor_table_display_name
      true
    rescue Exception => e
      false
    end

    def check_available_vendor_to_edit
      if list_vendor_displayed?
        first_vendor_table_display_name.click
      else
        add_vendor_btn.click
      end      
    end

    def verify_vendor_list_deleted
      wait_until_first_vendor_table_display_name_invisible
      expect(has_no_first_vendor_table_display_name?).to be true
    end

    def delete_vendor(type)
      if type.eql? 'all'
        wait_until_check_all_visible
        check_all.click
      elsif type.eql? 'single'
        wait_until_first_check_box_visible
        first_check_box.click
      end    
      bulk_delete_btn.click
      wait_for_ajax
      wait_until_confirm_delete_btn_visible
      confirm_delete_btn.click
      wait_for_ajax
      wait_until_ok_btn_visible
      ok_btn.click
      wait_for_ajax
    end

    def search_vendor_name(vendor_detail)
      search.set vendor_detail
      search.send_keys :enter
    end
end