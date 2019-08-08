require_relative "../sections/side_menu_section.rb"

class RegistersIndexPage < SitePrism::Page
    include RSpec::Matchers
    include BaseHelper
    set_url "/registers/index"
    set_url_matcher %r{/registers/index}

    section :side_menu, SideMenuPage, "#side-menu"
    element :add_account_btn, :xpath, "//a[@href='/registers/new']"
    element :add_new_transaction_btn, :xpath, "//i[@class='fa fa-plus']/following-sibling::span"
    element :add_reconcile_rules_btn, :xpath, "//a[@href='/bank_rules']"
    element :first_table_account_code, :xpath, "(//tr[@class='report-subheader']/following-sibling::tr/td/following-sibling::td)[1]"
    element :first_table_account_name, :xpath, "(//tr[@class='report-subheader']/following-sibling::tr/td/following-sibling::td/a)[1]"
    element :last_table_account_name, :xpath, "(//a[starts-with(@href,'/registers/detail')])[last()]"
    element :last_table_sub_account_name, :xpath, "(//a[starts-with(@href,'/registers/detail')])[last()]/following-sibling::div"
    element :last_table_account_code, :xpath, "//tr[@class='collapse in'][last()]/td[2]"
    elements :list_of_sub_accounts, :xpath, "(//tr[not(contains(@class,'bold '))]//a[contains(@href, '/registers/detail/')])"

    def list_account_displayed?
      first_table_account_code
      true
    rescue Exception => e
      false
    end

    def verify_new_account_details(created_account)
      expect(has_text?(created_account[:account_name])).to be true
      expect(has_text?(created_account[:account_description])).to be true
    end

    def target_account_to_edit(account_name)
      custom_click("xpath://a[contains(text(),'#{account_name}')]")
    end

    def check_available_account_to_edit
      if has_no_first_table_account_code?
        custom_click(add_account_btn)
        false
      else
        true
      end      
    end

    def verify_created_account_deleted(created_account)
      if list_account_displayed?
        expect(last_table_account_name.text).not_to eq created_account[:account_name]
      else
        expect(has_no_last_table_account_name?).to be true
      end
    end
end