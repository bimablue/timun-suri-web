Feature: To test cash and bank in Jurnal  

@smoke-test
Scenario: User able to open create new cash and bank account via click the menu/button
  Given user login as "user_owner_cash_bank_new_account"
  When user is on cash and bank page
  Then user is on create new cash and bank page
  And user unable to create empty account

Scenario: User able to create new account with details none
  Given user login as "user_owner_cash_bank_new_account"
  When user create 1 new account as category cash and bank with details sub account and with PPN tax
  Then user verify new cash and bank details as inputted

Scenario: User able to delete account
  Given user login as "user_owner_cash_bank_new_account"
  When user is on cash and bank page
  And user delete created account
  Then user verify created account deleted

Scenario: User able to create new account with category credit card
  Given user login as "user_owner_cash_bank_new_account"
  When user create 1 new account as category credit card with details header account and with PPN tax
  Then user verify new cash and bank details as inputted

  And user delete created account
  Then user verify created account deleted

Scenario: User able to edit account
  Given user login as "user_owner_cash_bank_new_account"
  When user create 1 new account as other details nil
  And user edit account details as category credit card with details header account and PPN tax
  Then user verify new cash and bank details as inputted

  And user delete created account
  Then user verify created account deleted

Scenario: User able create new transfer funds
  Given user login as "user_owner_cash_bank_transaction"
  When user create 1 transfer from created resource account to created destination account with amount 2000 at "20/08/2017"
  Then user verify transfer funds details

Scenario: User able create new transfer funds using created bank account
  Given user login as "user_owner_cash_bank_transaction"
  When user create 1 new account as category cash and bank with details sub account and with PPN tax
  And user create 1 new account as other details nil
  And user create 1 transfer from created resource account to created destination account with amount 2000 at "21/05/2017"
  Then user verify transfer funds details

Scenario: User able edit new transfer funds
  Given user login as "user_owner_cash_bank_transaction"
  And user is on cash and bank page
  When user edit transfer funds with amount 10000 at "20/09/2015"
  Then user verify transfer funds details

Scenario: User able create new receive money
  Given user login as "user_owner_cash_bank_transaction"
  When user create 1 receive money from 1 resource account to destination account as "customer" with amount 5000 at "20/08/2017"
  Then user verify receive money details

Scenario: User able create new receive money using created bank account
  Given user login as "user_owner_cash_bank_transaction"
  And user create 1 new account as other details nil
  And user create 1 new account as category cash and bank with details sub account and with PPN tax
  When user create 1 receive money from 1 resource account to destination account as "customer" with amount 5000 at "20/08/2017"
  Then user verify receive money details

Scenario: User able create new receive money more than one receiver
  Given user login as "user_owner_cash_bank_transaction"
  When user create 1 receive money from 3 resource account to destination account as "vendor" with amount 5000 at "20/08/2017"
  Then user verify receive money details

Scenario: User able create new receive money more than once
  Given user login as "user_owner_cash_bank_transaction"
  When user create 2 receive money from 1 resource account to destination account as "vendor" with amount 5000 at "20/08/2017"
  Then user verify receive money details

Scenario: User able create new receive money more than once
  Given user login as "user_owner_cash_bank_transaction"
  When user create 1 receive money from 1 resource account with out tax
  Then user verify receive money details

Scenario: User able edit new transfer funds
  Given user login as "user_owner_cash_bank_transaction"
  And user is on cash and bank page
  When user edit receive money with amount 10000 at "06/06/2006"
  Then user verify receive money details