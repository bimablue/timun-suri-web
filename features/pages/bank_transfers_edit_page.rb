class BankTransfersEditPage < SitePrism::Page
    include GeneratorFaker
    include BaseHelper
    include RSpec::Matchers
    set_url_matcher %r{/bank_transfers/.*/edit}
  
    element :transfer_from_dropdown, '#s2id_transaction_refund_from_id a span.select2-chosen'
    element :deposit_to_dropdown, '#s2id_transaction_deposit_to_id a span.select2-chosen'
    element :transaction_amount, '#transaction_transfer_amount'
    element :transaction_memo, "#transaction_memo"
    element :tags_dropdown, "#s2id_autogen3"
    element :transaction_date, "#transaction_transaction_date"
    element :update_btn, "#button_submit"
    element :cancel_btn, ".btn-danger"
    element :add_account, :xpath, "(//a[text()='+ Type to Add'] | //div[text()='+ Type to Add'])[1]"
    element :transfer_account_name, :xpath, "(//input[@id='account_name'])[2]"
    element :transfer_account_tax, "#select2-chosen-5"
    element :deposit_account_tax, "#select2-chosen-4"
    element :deposit_account_name, :xpath, "(//input[@id='account_name'])[1]"
    element :add_new_account, "#add-new-account"
    element :add_new_deposit, "#add-new-deposit-to"
    element :add_new_tag, "#newTerm, #select2-result-label-0"
    element :tags_text, "li.select2-search-choice"
    element :upload_preview, "#dropzonePreview"
    elements :delete_tags, "a.select2-search-choice-close"
    @@register_account_title = "css:#modal-label"
    @@upload_pict_btn = "//input[@type='file']"
    @@pict_path = "./features/data/images/cute_potato.png"

    def edit_transaction_details(transaction_details, amount, date)
      select_transfer_from transaction_details[0]
      select_deposit_to transaction_details[1]
      transaction_amount.set ""
      transaction_amount.set amount
      select_tags transaction_details[0]
      transaction_memo.set transaction_details[0][:account_description]
      select_date(transaction_date, date)
      wait_until_upload_preview_visible
    end

    def select_tags(value)
      if has_delete_tags?
        delete_tags.each{|j| j.click}
      end
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
  
  