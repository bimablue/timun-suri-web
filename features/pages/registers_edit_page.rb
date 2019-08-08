class RegistersEditPage < SitePrism::Page
    include RSpec::Matchers
    include BaseHelper
    set_url "/registers/edit"
    set_url_matcher %r{/registers/edit/.*}

    element :account_name_field, "#account_name"
    element :account_number_field, "#account_number"
    element :account_description_field, "#account_description"
    element :account_category_dropdown, "#select2-chosen-1"
    element :account_sub_details_sub_account_dropdown, "#select2-chosen-2"
    element :account_bank_name_dropdown, "#select2-chosen-3"
    element :account_tax_dropdown, "#select2-chosen-4"
    element :account_start_balance_edit_btn, :xpath, "//a[@href='/conversion_balances/setup']"
    element :update_account_btn, :xpath, "//button[text()='Update Account']"
    element :cancel_account_btn, :xpath, "//a[starts-with(@href,'/registers/detail/')]"
    element :account_setup_btn, "#learn-more"
    elements :list_detail_sub, '#select2-results-2 li div'

    def edit_details(account_data)
      select_category account_data[:account_category]
      account_name_field.set account_data[:account_name]
      account_description_field.set account_data[:account_description]
      select_sub_account account_data[:account_sub_details]
      select_tax account_data[:account_tax]
      select_bank account_data[:account_bank_name]
      update_account_btn.click
    end

    def select_category(value)
      select_dropdown account_category_dropdown, value
      if value == 'Credit Card'
        expect(account_number_field.value).to include '2-'
        expect(has_no_account_setup_btn?).to eq true
        expect(has_no_account_bank_name_dropdown?).to eq true
      else
        expect(account_number_field.value).to include '1-'
        expect(has_account_setup_btn?).to eq true
        expect(has_account_bank_name_dropdown?).to eq true
      end
    end

    def select_sub_account(value)
      unless value.empty?
        select_dropdown account_sub_details_sub_account_dropdown, value
      else
        account_sub_details_sub_account_dropdown.click
        list_detail_sub.sample.click
      end
    end

    def select_tax(value)
      unless value.nil?
        select_dropdown account_tax_dropdown, value
      end
    end

    def select_bank(value)
      unless (value.nil?) & (account_category_dropdown.text == 'Credit Card')
        select_dropdown account_bank_name_dropdown, value
      end
    end
end