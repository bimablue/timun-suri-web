class BankTransfersPage < SitePrism::Page
    include GeneratorFaker
    include BaseHelper
    include RSpec::Matchers
    set_url_matcher %r{.*/bank_transfers/.*}
  
    element :transfer_from, :xpath, "//label[contains(text(),'Transfer From')]/following-sibling::div/a"
    element :deposit_to, :xpath, "//label[contains(text(),'* Deposit To')]/following-sibling::div"
    element :transaction_amount, :xpath, "//label[contains(text(),'Amount')]/following-sibling::div"
    element :transaction_memo, :xpath, "//label[contains(text(),'Memo')]/following-sibling::div"
    element :transaction_tags, :xpath, "//label[contains(text(),'Tags')]/following-sibling::div"
    element :transaction_date, :xpath, "//label[contains(text(),'Transaction Date:')]/following-sibling::div"
    element :transaction_no, :xpath, "//label[contains(text(),'Transaction No:')]/following-sibling::div"
    element :create_transfer_btn, "#create_button"
    element :delete_btn, "#btn"
    element :back_btn, :xpath, "//a[text()='Back']"
    element :edit_btn, :xpath, "//a[contains(text(),'Edit')]"
    element :action_btn, :xpath, "//button[contains(text(),'Actions')]"
    element :clone_transaction_btn, :xpath, "//a[contains(text(),'Clone Transaction')]"
    element :set_recurring_btn, :xpath, "//a[contains(text(),'Set as Recurring')]"
    element :previous_btn, "a[class='btn btn-default btn-default-border']"

    def verify_tranfer_details(accounts, amount, date) 
      expect(transfer_from.text).to eq accounts[0][:account_name]
      expect(deposit_to.text).to eq accounts[1][:account_name]
      expect(transaction_date.text).to eq date
      expect(transaction_amount.text.gsub(/(?<=\d)\.(?=\d)/, '')).to eq "Rp. " + amount.to_s + ",00\nview journal entry"
      expect(transaction_memo.text).to eq accounts[0][:account_description]
      expect(transaction_no.text).to match(/\d/)
      expect(transaction_tags.text).to eq accounts[0][:account_tags]
    end
end