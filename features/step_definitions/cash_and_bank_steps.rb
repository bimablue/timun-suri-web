Given(/^user is on cash and bank page$/) do
	custom_click(@app.registers_index.side_menu.cash_and_bank_btn)
	expect(@app.registers_index).to be_displayed
	expect(@app.registers_index.add_account_btn.visible?).to be true
end

Given(/^user is on create new cash and bank page$/) do
 	custom_click(@app.registers_index.add_account_btn)
 	expect(@app.registers_new).to be_displayed
 	expect(@app.registers_new.account_name_field.visible?).to be true
end
 
When "user create {int} new account as {string}" do |number, account_name|
	@app.registers_index.load
	@account = @app_requirement.account.load_account_details(account_name)
	@stored_account ||= []
	for i in 1..number
		@generate_account = faker_cash_and_bank_page_new(@account['category'], @account['details'], @account['sub_details'], @account['tax'], @account['bank_name'])
		account_name = "xpath://a[text()='#{@generate_account[:account_name]}']"
		if element_displayed? account_name
			custom_click(account_name)
			custom_click(@app.registers_detail.action_btn)
			custom_click(@app.registers_detail.action_delete_btn)
		else
			custom_click(@app.registers_index.add_account_btn)
			@app.registers_new.fill_account_details @generate_account
			if number > 1 && i != number
				@app.registers_new.create_account_dropdown_btn.click
				@app.registers_new.create_account_dropdown_list_create_new_option.click
				@app.registers_new.create_account_and_new_btn.click
			else
				@app.registers_new.create_account_btn.click
			end
		end
		@stored_account << @generate_account
	end
end

Then(/^user verify new cash and bank details as inputted$/) do
	@app.registers_index.verify_new_account_details	 @generate_account
end

Then(/^user delete created account$/) do
	unless @app.registers_index.list_account_displayed?
		step "user create 1 new account"
	end
	@generate_account ||= {'account_name': @app.registers_index.last_table_account_name.text.strip()} 
	custom_click("xpath:(//a[contains(normalize-space(text()),'#{@generate_account[:account_name]}')])[last()]")
	@app.registers_detail.delete_account
end

Then(/^user verify created account deleted$/) do
	@app.registers_index.verify_created_account_deleted @generate_account
end

When "user edit account details as {string}" do |account|
	unless @app.registers_index.check_available_account_to_edit
	  @generate_account = faker_cash_and_bank_page_new
	  @app.registers_new.fill_account_details @generate_account
	end 
	@generate_account ||= {'account_name': @app.registers_index.first_table_account_name.text} 
	@app.registers_index.target_account_to_edit @generate_account[:account_name]
	@app.registers_detail.edit_account
	@generate_account = faker_cash_and_bank_page_new
	@app.registers_edit.edit_details @generate_account
end

And "user edit account details as category credit card with details header account and PPN tax" do
	unless @app.registers_index.check_available_account_to_edit
	  @generate_account = faker_cash_and_bank_page_new
	  @app.registers_new.fill_account_details @generate_account
	end 
	@generate_account ||= {'account_name': @app.registers_index.first_table_account_name.text} 
	@app.registers_index.target_account_to_edit @generate_account[:account_name]
	@app.registers_detail.edit_account
	@generate_account = faker_cash_and_bank_page_new
	@app.registers_edit.edit_details @generate_account
end

When "user create {int} transfer from created resource account to created destination account with amount {int} at {string}" do |number, transaction_amount, transaction_date|
	@app.bank_transfers_new.load
	for j in 1..number
		@stored_account ||= []
		if @stored_account.length == 0
			for k in 0..1
			  @stored_account << @generate_account = faker_cash_and_bank_page_new
			end
		end
	  @transaction_amount = transaction_amount
	  @transaction_date = transaction_date
	  @app.bank_transfers_new.fill_transaction_details(@stored_account, @transaction_amount, @transaction_date)
	  if number > 1 && j != number
		  @app.bank_transfers_new.create_transfer_dropdown.click
		  @app.bank_transfers_new.create_new_transfer_list.click
		  @app.bank_transfers_new.create_new_transfer_btn.click
		  @stored_account.clear
	  else
		  @app.bank_transfers_new.create_transfer_btn.click
	  end
	end
end

Then "user verify transfer funds details" do
	@app.bank_transfers.verify_tranfer_details(@stored_account, @transaction_amount, @transaction_date)
end

And "user unable to create empty account" do
	@app.registers_new.create_account_btn.click
	expect(page).to have_content('Name (Please insert account name)')
	expect(@app.registers_new.account_name_underline_text.text).to eq '(Please insert account name)'
end

And "user create {int} new account as category cash and bank with details sub account and with PPN tax" do |number|
	@app.registers_index.load
	@stored_account ||= []
	for i in 1..number
		@generate_account = faker_cash_and_bank_page_new
		@generate_account[:account_category] = 'Cash & Bank'
		@generate_account[:account_details] = 'Sub Account of :'
		@generate_account[:account_tax] = 'PPN'
		account_name = "xpath://a[text()='#{@generate_account[:account_name]}']"
		if element_displayed? account_name
			custom_click(account_name)
			custom_click(@app.registers_detail.action_btn)
			custom_click(@app.registers_detail.action_delete_btn)
		else
			custom_click(@app.registers_index.add_account_btn)
			@app.registers_new.fill_account_details @generate_account
			if number > 1 && i != number
				@app.registers_new.create_account_dropdown_btn.click
				@app.registers_new.create_account_dropdown_list_create_new_option.click
				@app.registers_new.create_account_and_new_btn.click
			else
				@app.registers_new.create_account_btn.click
			end
		end
		@stored_account << @generate_account
	end
end

And "user create {int} new account as category credit card with details header account and with PPN tax" do |number|
	@app.registers_index.load
	@stored_account ||= []
	for i in 1..number
		@generate_account = faker_cash_and_bank_page_new
		@generate_account[:account_category] = 'Credit Card'
		@generate_account[:account_details] = 'Header Account of :'
		@generate_account[:account_tax] = 'PPN'
		account_name = "xpath://a[text()='#{@generate_account[:account_name]}']"
		if element_displayed? account_name
			custom_click(account_name)
			custom_click(@app.registers_detail.action_btn)
			custom_click(@app.registers_detail.action_delete_btn)
		else
			custom_click(@app.registers_index.add_account_btn)
			@app.registers_new.fill_account_details @generate_account
			if number > 1 && i != number
				@app.registers_new.create_account_dropdown_btn.click
				@app.registers_new.create_account_dropdown_list_create_new_option.click
				@app.registers_new.create_account_and_new_btn.click
			else
				@app.registers_new.create_account_btn.click
			end
		end
		@stored_account << @generate_account
	end
end

And "user create {int} new account as other details nil" do |number|
	@app.registers_index.load
	@stored_account ||= []
	for i in 1..number
		@generate_account = faker_cash_and_bank_page_new
		@generate_account[:account_details] = ''
		@generate_account[:account_tax] = ''
		@generate_account[:account_bank_name] = ''
		account_name = "xpath://a[text()='#{@generate_account[:account_name]}']"
		if element_displayed? account_name
			custom_click(account_name)
			custom_click(@app.registers_detail.action_btn)
			custom_click(@app.registers_detail.action_delete_btn)
		else
			custom_click(@app.registers_index.add_account_btn)
			@app.registers_new.fill_account_details @generate_account
			if number > 1 && i != number
				@app.registers_new.create_account_dropdown_btn.click
				@app.registers_new.create_account_dropdown_list_create_new_option.click
				@app.registers_new.create_account_and_new_btn.click
			else
				@app.registers_new.create_account_btn.click
			end
		end
		@stored_account << @generate_account
	end
end

When "user create {int} receive money from {int} resource account to destination account as {string} with amount {int} at {string}" do |repetition, total_receiver, payer, amount, date|
	@app.bank_deposits_new.load
	@payer_details ||= faker_contact_new
	for j in 1..repetition
	  @stored_account ||= []
	  if @stored_account.length == 0
		for k in 0..total_receiver
			@stored_account << @generate_account = faker_cash_and_bank_page_new
		end
	  end
	  @transaction_amount = amount
	  @transaction_date = date
	  @app.bank_deposits_new.fill_receiving_details(@stored_account, total_receiver, payer, @payer_details, @transaction_amount, @transaction_date)
	  if repetition > 1 && j != repetition
			@app.bank_deposits_new.create_deposits_dropdown.click
			@app.bank_deposits_new.create_new_deposits_list.click
			@app.bank_deposits_new.create_new_deposits_btn.click
			@stored_account.clear
	  else
			@app.bank_deposits_new.create_deposits_btn.click
	  end
	end
end

When "user create {int} receive money from {int} resource account with out tax" do |repetition, total_receiver|
	@app.bank_deposits_new.load
	@payer_details ||= faker_contact_new
	for j in 1..repetition
	  @stored_account ||= []
	  if @stored_account.length == 0
			for k in 0..total_receiver
				@stored_account << @generate_account = faker_cash_and_bank_page_new
				@stored_account[k][:account_tax] = ""
			end
	  end
	  @transaction_amount = "5000"
	  @transaction_date = "20/08/2017"
	  @app.bank_deposits_new.fill_receiving_details(@stored_account, total_receiver, "vendor", @payer_details, @transaction_amount, @transaction_date)
	  if repetition > 1 && j != repetition
			@app.bank_deposits_new.create_deposits_dropdown.click
			@app.bank_deposits_new.create_new_deposits_list.click
			@app.bank_deposits_new.create_new_deposits_btn.click
			@stored_account.clear
	  else
			@app.bank_deposits_new.create_deposits_btn.click
	  end
	end
end

Then "user verify receive money details" do
	@app.bank_deposits.verify_tranfer_details(@stored_account, @payer_details, @transaction_amount, @transaction_date)
end

And "user edit transfer funds with amount {int} at {string}" do |amount, date|
	@app.registers_index.load
	sub_account_index = Random.rand(1..@app.registers_index.list_of_sub_accounts.count)
	@app.registers_index.list_of_sub_accounts[sub_account_index-1].click
	@stored_account ||= []
	@app.registers_detail.input_search.set "Transfer"
	@app.registers_detail.search_btn.click
	unless element_displayed? @app.registers_detail.transaction_list, 3
		custom_click(@app.registers_detail.new_transaction_btn)
		@app.registers_detail.transfer_funds.click
		if @stored_account.length == 0
				@stored_account << @generate_account = faker_cash_and_bank_page_new
		end
		@app.bank_transfers_new.fill_registers_detail_transaction @stored_account
		custom_click(@app.bank_transfers_new.create_transfer_btn)
		@app.bank_transfers.wait_for_transfer_from
		@app.bank_transfers.wait_until_transfer_from_visible
		@app.bank_transfers.transfer_from.click
	end
	@app.registers_detail.wait_until_transaction_list_visible
	@app.registers_detail.input_search.set "Transfer"
	@app.registers_detail.search_btn.click
	@app.registers_detail.wait_until_transaction_list_visible
	transaction_index = Random.rand(1..@app.registers_detail.transaction_list.count)
	@app.registers_detail.transaction_list[transaction_index-1].click
	@app.bank_transfers.edit_btn.click
	@transaction_amount = amount
	@transaction_date = date
	if @stored_account.length > 0
		@stored_account.clear
	end
	for k in 0..1
		@stored_account << @generate_account = faker_cash_and_bank_page_new
	end
	@app.bank_transfers_edit.edit_transaction_details @stored_account, @transaction_amount, @transaction_date
	@app.bank_transfers_edit.update_btn.click
end

And "user edit receive money with amount {int} at {string}" do |amount, date|
	@app.registers_index.load
	sub_account_index = Random.rand(1..@app.registers_index.list_of_sub_accounts.count)
	account_name = @app.registers_index.list_of_sub_accounts[sub_account_index-1].text
	@app.registers_index.list_of_sub_accounts[sub_account_index-1].click
	@stored_account ||= []
	@payer_details ||= faker_contact_new
	@app.registers_detail.input_search.set "Deposit"
	@app.registers_detail.search_btn.click
	unless element_displayed? @app.registers_detail.transaction_list, 3
		custom_click(@app.registers_detail.new_transaction_btn)
		@app.registers_detail.receive_money.click
		if @stored_account.length == 0
			for k in 0..3
				@stored_account << @generate_account = faker_cash_and_bank_page_new
			end
			@stored_account[0][:account_name] = account_name
		end
		@app.bank_deposits_new.fill_receiving_details @stored_account, 1, "vendor", @payer_details, 1000, "06/01/2019"
		custom_click(@app.bank_deposits_new.create_deposits_btn)
		@app.bank_deposits.wait_for_account_name_list
		@app.bank_deposits.wait_until_account_name_list_visible
		find_xpath("//a[contains(text(),#{account_name}) and contains(@href,'/registers/detail/')]").click
		# @app.bank_deposits.account_name_list.select{|name| name.text == account_name}
		# @app.bank_deposits.deposit_to.click
	end
	@app.registers_detail.wait_until_transaction_list_visible
	@app.registers_detail.input_search.set "Deposit"
	@app.registers_detail.search_btn.click
	@app.registers_detail.wait_until_transaction_list_visible
	transaction_index = Random.rand(1..@app.registers_detail.transaction_list.count)
	@app.registers_detail.transaction_list[transaction_index-1].click
	@app.bank_deposits.edit_btn.click
	@transaction_amount = amount
	@transaction_date = date
	if @stored_account.length > 0 && @payer_details.length > 0
		@stored_account.clear
		@payer_details.clear
		@payer_details = faker_contact_new
	end
	count = @app.bank_deposits_edit.receiving_from_dropdown.count
	for k in 0..count
		@stored_account << @generate_account = faker_cash_and_bank_page_new
	end
	@app.bank_deposits_edit.edit_receiving_details @stored_account, count-1, "vendor", @payer_details, @transaction_amount, @transaction_date
	@app.bank_deposits_edit.update_btn.click
end