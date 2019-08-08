class RegistersDetailPage < SitePrism::Page
    include RSpec::Matchers
    set_url "/registers/detail"
    set_url_matcher %r{/registers/detail}

    element :action_btn, :xpath, "//span[text()='Action']"
    element :action_delete_btn, :xpath, "//a[contains(text(),'Delete Account')]"
    element :yes_btn, :xpath, "(//button[text()='Yes'])[2]"
    element :no_btn, :xpath, "(//button[text()='No'])[1]"
    element :edit_btn, :xpath, "//a[starts-with(@href,'/registers/edit/')]"
    element :input_search, "#at_search_input"
    element :search_btn, "#at-filter+button .fa-search"
    elements :transaction_list, ".account-transaction-desc a[href]"
    element :new_transaction_btn, "button.btn-action-recon .fa-plus"
    element :transfer_funds, "ul.right14em li a", text: "+ Transfer Funds"
    element :receive_money, "ul.right14em li a", text: "+ Receive Money"
    element :pay_money, "ul.right14em li a", text: "+ Pay Money"

    def delete_account
      action_btn.click
      action_delete_btn.click
      wait_until_yes_btn_visible 30
      yes_btn.click
    end

    def fill_account_details(account_data)
      account_name_field.set account_data[:vendor_email]
      account_number_field.set account_data[:display_name]
      account_description_field.set account_data[:vendor_tax_no]
    end

    def edit_account
      action_btn.click
      edit_btn.click
    end
end