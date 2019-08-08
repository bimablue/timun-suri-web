class BankTransfersNewPage < SitePrism::Page
    include GeneratorFaker
    include BaseHelper
    include RSpec::Matchers
    set_url "/bank_transfers/new"
    set_url_matcher %r{/bank_transfers/new}
  
    element :transfer_from_dropdown, '#select2-chosen-6'
    element :deposit_to_dropdown, '#select2-chosen-7'
    element :transaction_amount, '#transaction_transfer_amount'
    element :transaction_memo, "#transaction_memo"
    element :tags_dropdown, "#s2id_autogen3"
    element :transaction_date, "#transaction_transaction_date"
    element :create_transfer_btn, "#create_button"
    element :create_transfer_dropdown, :xpath, "//input[@id='create_button']/following-sibling::button"
    element :create_new_transfer_list, :xpath, "//td[contains(text(),'Create & New')]"
    element :create_new_transfer_btn, "#create_and_new_button"
    element :cancel_btn, :xpath, "(//a[@href='/registers/index'])[2]"
    element :add_account, :xpath, "(//a[text()='+ Type to Add'] | //div[text()='+ Type to Add'])[1]"
    element :transfer_account_name, :xpath, "(//input[@id='account_name'])[2]"
    element :transfer_account_tax, "#select2-chosen-5"
    element :deposit_account_tax, "#select2-chosen-4"
    element :deposit_account_name, :xpath, "(//input[@id='account_name'])[1]"
    element :add_new_account, "#add-new-account"
    element :add_new_deposit, "#add-new-deposit-to"
    element :add_new_tag, "#newTerm, #select2-result-label-0"
    element :upload_preview, "#dropzonePreview"
    @@register_account_title = "css:#modal-label"
    @@upload_pict_btn = "//input[@type='file']"
    @@pict_path = "./features/data/images/cute_potato.png"

    def fill_transaction_details(transaction_details, amount, date)
      select_transfer_from transaction_details[0]
      select_deposit_to transaction_details[1]
      transaction_amount.set amount
      transaction_memo.set transaction_details[0][:account_description]
      select_tags transaction_details[0]
      select_date(transaction_date, date)
      page.driver.browser.all(:xpath, @@upload_pict_btn).last.send_keys(File.absolute_path(@@pict_path)) 
      wait_until_upload_preview_visible
    end

    def fill_registers_detail_transaction(transaction_details)
      transaction_amount.set "10000"
      transaction_memo.set transaction_details[0][:account_description]
      select_tags transaction_details[0]
      page.driver.browser.all(:xpath, @@upload_pict_btn).last.send_keys(File.absolute_path(@@pict_path)) 
      wait_until_upload_preview_visible
    end

    def select_tags(value)
      tags_dropdown.set value[:account_tags]
      wait_until_add_new_tag_visible
      tags_dropdown.set "\n"
    end

    def select_transfer_from(value)
      unless (select_dropdown transfer_from_dropdown, value[:account_name]) & !(element_displayed? @@register_account_title)
        wait_until_transfer_account_name_visible 5
        transfer_account_name.set value[:account_name]
        select_dropdown transfer_account_tax, value[:account_tax]
        add_new_account.click
        wait_until_transfer_account_name_invisible
      end
    end

    def select_deposit_to(value)
      unless (select_dropdown deposit_to_dropdown, value[:account_name]) & !(element_displayed? @@register_account_title)
        wait_until_deposit_account_name_visible 5
        deposit_account_name.set value[:account_name]
        select_dropdown deposit_account_tax, value[:account_tax]
        add_new_deposit.click
        wait_until_deposit_account_name_invisible
      end
    end
end
  
  