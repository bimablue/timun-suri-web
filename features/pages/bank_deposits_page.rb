class BankDepositsPage < SitePrism::Page
    include GeneratorFaker
    include BaseHelper
    include RSpec::Matchers
    set_url_matcher %r{.*/bank_deposits/.*}
  
    element :payer, ".detail-1 dd a"
    element :deposit_to, ".info-1 dd a"
    element :transaction_amount, "span#header_amount"
    element :transaction_memo, :xpath, "//label[contains(text(),'Memo')]/following-sibling::div"
    element :transaction_tags, ".detail-4 dd a"
    element :transaction_date, ".detail-2 dd"
    element :transaction_no, :xpath, "//dt[contains(text(),'Transaction No:')]/following-sibling::dd"
    element :create_transfer_btn, "#create_button"
    element :delete_btn, "#btn"
    element :back_btn, :xpath, "//a[text()='Back']"
    element :edit_btn, :xpath, "//a[contains(text(),'Edit')]"
    element :action_btn, :xpath, "//button[contains(text(),'Actions')]"
    element :clone_transaction_btn, :xpath, "//a[contains(text(),'Clone Transaction')]"
    element :set_recurring_btn, :xpath, "//a[contains(text(),'Set as Recurring')]"
    element :previous_btn, "a[class='btn btn-default btn-default-border']"
    element :alert_message, ".alert.fade.in"
    element :deposit_status, ".text-right h1"
    element :transaction_header, ".page-title-heading h2"
    elements :account_name_list, ".table-header+tbody#group_lines tr td a"
    elements :account_description_list , ".table-header+tbody#group_lines tr td+td:nth-child(2)"
    elements :account_tax_list, ".table-header+tbody#group_lines tr td+td:nth-child(3)"
    elements :account_amount_list, ".table-header+tbody#group_lines .text-right"
    element :sub_total_amount, "dd#total:nth-child(2)"
    element :total_amount, ".amount-due+dd#total"
    element :total_tax, "dd#total+dt+dd"
    element :print_preview_btn, :xpath, "//button[contains(text(),'Print & Preview')]"
    element :preview_dropdown, :xapath, "//button[contains(text(),'Print & Preview')]/following-sibling::button"
    element :preview_receipt_btn, :xpath, "//a[contains(text(),'Preview Cash Receipt')]"
    element :view_jurnal_entry, :xpath, "//a[contains(text(),'view journal entry')]"
    elements :uploaded_pic, "a[target='_blank']"
    elements :total_tax_list, ".text-right+dt"

    def verify_tranfer_details(accounts, payer_details, amount, date) 
      expect(payer.text).to eq payer_details[:contact_name]
      expect(deposit_to.text).to eq accounts[0][:account_name]
      expect(transaction_date.text).to eq date
      uploaded_pic.each{|x| expect(x.text).to eq "cute_potato.png"}
      expect(account_total_amount).to eq sub_total_amount.text.gsub(/(?<=\d)\.(?=\d)/, '').gsub('Rp. ', '').to_i
      expect(transaction_memo.text).to eq accounts[0][:account_description]
      expect(transaction_no.text).to match(/\d/)
      expect(transaction_tags.text).to eq accounts[0][:account_tags]
      expect_account_list_name accounts
      expect_account_list_description accounts
      expect_account_list_tax accounts
      expect_account_list_amount amount
      expect_count_tax
    end

    def account_total_amount
      tax_map = account_amount_list.map {|rows| rows.text.gsub(/(?<=\d)\.(?=\d)/, '').gsub('Rp. ', '').to_i}
      tax_map.sum
    end

    def expect_account_list_name(accounts)
      account_name_list.each_with_index{|account_name, index| expect(account_name.text).to eq accounts[index+1][:account_name]}
    end

    def expect_account_list_description(accounts)
      account_description_list.each_with_index{|account_desc, index| expect(account_desc.text).to eq accounts[index+1][:account_description]}
    end

    def expect_account_list_tax(accounts)
      tax_names = account_tax_list.map {|rows| rows.text}
      unless tax_names.any?{|x| x.include? 'Rp. ' }
        account_tax_list.each_with_index do |account_tax, index| 
          expect(account_tax.text).to eq accounts[index+1][:account_tax]
        end      
      end
    end

    def expect_account_list_amount(amount)
      account_amount_list.each_with_index{|account_amount, index| expect(account_amount.text.gsub(/(?<=\d)..(?=\d)/, '').gsub('Rp. ', '').to_f).to eq amount.to_f}
    end

    def expect_count_tax
      amount_list = []
      tax_name_counts = Hash.new(0)
      tax_names = account_tax_list.map {|rows| rows.text}
      unless tax_names.any?{|x| x.include? 'Rp. ' }
        tax_names.each { |name| tax_name_counts[name] += 1 }
        tax_name_counts.each do |key, value| 
          unless key.empty?
            tax_percent = find('.text-right+dt', text: key).text.split(' ')[1]
            for j in 1..value
              amount_list << {"#{key}": (find(:xpath, "(//td[contains(text(),'#{key}')]/following-sibling::td)[#{j}]").text.gsub(/(?<=\d)..(?=\d)/, '').gsub('Rp. ', '').to_i * tax_percent.to_i/100)}
            end
          end
        end
        total_tax_amount = amount_list.inject{|memo, el| memo.merge(el){|k, old_v, new_v| old_v + new_v}}
        total_tax_amount.each {|key, value| expect(find(:xpath, "(//dt[contains(text(),'#{key}')]/following-sibling::dd[@class='text-right'])[1]").text.gsub('Rp. ', '').gsub('.','').gsub(',00','').to_i).to eq value}
      else
        expect(element_displayed? "xpath://*[contains(text(), '.0%')]").to be false
        expect(total_tax_list).not_to include(" %")
      end
    end
end