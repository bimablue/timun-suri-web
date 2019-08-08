class BankDepositsEditPage < SitePrism::Page
  include GeneratorFaker
  include BaseHelper
  include RSpec::Matchers
  set_url_matcher %r{.*/bank_deposits/.*/edit}

  element :payer_dropdown, "div.contact-details span.select2-chosen"
  element :payer_account_name, "#person_display_name"
  # element :payer_account_tax, "#s2id_autogen13"
  element :payer_account_email, "#person_email"
  element :payer_account_bill_address, "#person_billing_address"
  element :payer_type_dropdown, "#s2id_person_people_type a.select2-choice span.select2-chosen"
  element :add_new_payer_btn, "#add-new-person"
  element :deposit_to_dropdown, "div.customer #s2id_transaction_deposit_to_id a.select2-choice span.select2-chosen"
  element :deposit_account_name, "#deposit-to-form #account_name"
  element :deposit_account_tax, "#deposit-to-form #s2id_account_company_tax_id a.select2-choice span.select2-chosen"
  element :deposit_account_category_dropdown, "#deposit-to-form #s2id_account_category_id a.select2-choice span.select2-chosen"
  element :add_new_deposit_to_btn, "#add-new-deposit-to"
  element :transaction_date, "#transaction_transaction_date"
  element :transaction_memo, "#transaction_memo"
  element :transaction_tags, "#s2id_transaction_tag_ids input"
  element :transaction_no, "#transaction_transaction_no"
  elements :receiving_from_dropdown, ".transaction_product.name-line a .select2-chosen"
  element :receiving_account_category, "#s2id_account_category_id a .select2-chosen"
  element :receiving_account_tax, "#s2id_account_company_tax_id a .select2-chosen"
  element :receiving_account_name, "#account_name"
  elements :receiving_account_description, "#group_lines textarea"
  elements :receiving_tax_dropdown, ".select2-container.form-control.selection-tooltip.tax-line.transaction_tax a .select2-chosen"
  elements :receiving_account_amount, ".amount-input"
  element :register_account_title, "#modal-label"
  element :add_new_account_btn, "#add-new-accounts"
  element :type_to_add_btn, "#newTerm, #select2-result-label-0"
  element :add_more_data_btn, :xpath, "//a[text()='+ Add More Data']"
  element :create_deposits_btn, "#create_button"
  element :create_deposits_dropdown, :xpath, "//input[@id='create_button']/following-sibling::button"
  element :create_new_deposits_list, :xpath, "//td[contains(text(),'Create & New')]"
  element :create_new_deposits_btn, "#create_and_new_button"
  element :price_include_tax_toggle_btn, "#transaction_use_tax_inclusive"
  element :sub_total_amount, "#transaction_account_line_total"
  element :header_total_amount, "#header_amount"
  elements :total_tax, ".tax_value"
  element :total_amount, "#transaction_subtotal"
  element :cancel_btn, :xpath, "//a[@href='/registers/index']"
  element :delete_btn, "#btn"
  elements :upload_preview, ".dropzone-file-row"
  elements :delete_uploaded_file_btn, "#dropzone-close"
  element :company_tax_name, "#company_tax_name"
  element :company_tax_rate, "#company_tax_rate"
  element :add_new_company_tax, "#add-new-company-tax"
  element :update_btn, "#button_submit"
  @@register_account_title = "css:#modal-label"
  @@dropdown_searching_text = "xpath://*[text()='Searching..."
  element :dropdown_input, :xpath, "//input[@aria-expanded = 'true' and starts-with(@id,'s2id_autogen')]"
  @@upload_pict_btn = "//input[@type='file']"
  @@pict_path = "./features/data/images/cute_potato.png"
  elements :delete_tags, "a.select2-search-choice-close"


  def edit_receiving_details(transaction_details, data_number, type, payer, amount, date)
    select_deposit_to transaction_details[0]
    select_payer payer, type
    select_date transaction_date, date
    select_tags transaction_details[0]
    select_receiver transaction_details, data_number, amount
    transaction_memo.set transaction_details[0][:account_description]
    header_total_amount.click
    expect(sub_total_amount.text.gsub(/[Rp. ]/, 'Rp' => '', '.' => '').to_i).to eq sum_amount
    expect(header_total_amount.text.gsub(/[Rp. ]/, 'Rp' => '', '.' => '').to_i).to eq sum_amount.to_i + sum_tax.to_i
    expect(total_amount.text.gsub(/[Rp. ]/, 'Rp' => '', '.' => '').to_i).to eq sum_amount.to_i + sum_tax.to_i
    page.driver.browser.all(:xpath, @@upload_pict_btn).last.send_keys(File.absolute_path(@@pict_path)) 
    wait_until_upload_preview_visible
  end

  def tax_exist?
    tax_map = receiving_tax_dropdown.map {|rows| rows.text}
    tax_map.any? {|x| x != 'Select tax' }
  end

  def select_tags(value)
    if has_delete_tags?
      delete_tags.each{|j| j.click}
    end
    transaction_tags.set value[:account_tags]
    wait_until_type_to_add_btn_visible
    transaction_tags.set "\n"
  end

  def select_receiver(value, count, amount)
    for j in 1..count
      value[j][:account_category] = 'Cash & Bank'
      if j > 2
        add_more_data_btn.click
      end
      unless (select_dropdown receiving_from_dropdown[j-1], value[j][:account_name]) & !(element_displayed? @@register_account_title)
        type_to_add_btn.click unless element_displayed? @@register_account_title
        wait_until_add_new_account_btn_visible
        custom_fill(receiving_account_name, value[j][:account_name])
        select_dropdown receiving_account_category, value[j][:account_category] unless receiving_account_category.text.eql? value[j][:account_category]
        select_dropdown receiving_account_tax, value[j][:account_tax] unless receiving_account_tax.text.eql? value[j][:account_tax]
        add_new_account_btn.click
        wait_until_add_new_account_btn_invisible 
      end
      receiving_account_description[j-1].set value[j][:account_description]
      select_tax receiving_tax_dropdown[j-1], value[j][:account_tax]
      # select_dropdown receiving_tax_dropdown[j-1], value[j][:account_tax] unless receiving_tax_dropdown[j-1].text.eql? value[j][:account_tax]
      receiving_account_amount[j-1].set ""
      receiving_account_amount[j-1].set amount
      wait_until_sub_total_amount_visible
      sub_total_amount.click
      receiving_from_dropdown[j-1].should have_content(value[j][:account_name])
      receiving_tax_dropdown[j-1].should have_content(value[j][:account_tax])
    end
  end

  def select_tax(dropdown, value)
    unless (value.empty?) || (dropdown.text.eql? value)
      unless ((select_dropdown dropdown, value) & !(element_displayed? @@register_account_title))
        dropdown_input.set 'PPN'
        expect(element_displayed? @@dropdown_searching_text).to be false
        dropdown_input.set "\n"
        dropdown.click
        wait_until_type_to_add_btn_visible
        type_to_add_btn.click 
        wait_until_company_tax_name_visible
        company_tax_name.set value
        company_tax_rate.set Random.rand(1..10)
        add_new_company_tax.click
      end
    end
  end

  def sum_amount
    sum = 0
    for j in 0..receiving_account_amount.count-1
      sum += receiving_account_amount[j].value.gsub(/[Rp. ]/, 'Rp. ' => '', '.' => '').to_i
    end
    sum
  end

  def sum_tax
    sum = 0
    if tax_exist?
      expect(has_total_tax?).to be true
      for j in 0..total_tax.count-1
        sum += total_tax[j].text.gsub(/[Rp. ]/, 'Rp. ' => '', '.' => '').to_i
      end
    end
    sum
  end

  def select_deposit_to(value)
    unless (select_dropdown deposit_to_dropdown, value[:account_name]) && !(element_displayed? @@register_account_title)
      type_to_add_btn.click unless element_displayed? @@register_account_title
      wait_until_deposit_account_name_visible
      custom_fill(deposit_account_name, value[:account_name])
      select_dropdown deposit_account_category_dropdown, value[:account_category] = 'Cash & Bank' unless deposit_account_category_dropdown.text.eql? 'Cash & Bank'
      select_dropdown deposit_account_tax, value[:account_tax]
      add_new_deposit_to_btn.click
      wait_until_add_new_deposit_to_btn_invisible
    end
    deposit_to_dropdown.should have_content(value[:account_name])
  end

  def select_payer(payer_details, type)
    payer_details[:contact_type] = 'vendor' if type.eql? 'vendor'
    unless (select_dropdown payer_dropdown, payer_details[:contact_name]) & !(element_displayed? @@register_account_title)
      type_to_add_btn.click unless element_displayed? @@register_account_title
      wait_until_add_new_payer_btn_visible
      custom_fill(payer_account_name, payer_details[:contact_name])
      select_dropdown payer_type_dropdown, payer_details[:contact_type] unless payer_type_dropdown.text.eql? payer_details[:contact_type]
      custom_fill(payer_account_email, payer_details[:contact_email])
      custom_fill(payer_account_bill_address, payer_details[:contact_bill_address])
      add_new_payer_btn.click
      wait_until_add_new_payer_btn_invisible
    end
    payer_dropdown.should have_content(payer_details[:contact_name])
  end
end
  
  