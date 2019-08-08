Feature: To test vendor in Jurnal

Background: User able to open vendor page
	Given user is on login page
	And login as "user_owner_1"
  And user is on vendor page

Scenario: User able to create new vendor
  When user create 1 new vendor
  Then user verify new vendor details as inputted
  And "vendor" message "vendor_success_created" displayed

  When user is on vendor page
  And user delete "all" vendor
  Then user verify vendor list deleted

Scenario: User able to delete vendor
  When user create 1 new vendor
  And user is on vendor page
  And user delete "single" vendor
  Then user verify vendor list deleted

Scenario: User able to edit vendor
  When user create 1 new vendor
  And user is on vendor page
  And user edit vendor details
  Then user verify new vendor details as inputted

  When user is on vendor page
  And user delete "all" vendor
  Then user verify vendor list deleted

Scenario: User able to bulk delete vendor
  When user create 2 new vendor
  And user is on vendor page
  And user delete "all" vendor
  Then user verify vendor list deleted

Scenario: User create vendor from purchase invoice page via "type to add" vendor dropdown
  Given user is on create purchase invoice page
  When user create "simple" new vendor via create purchase invoice
  
  Then user is on vendor page
  And user delete "all" vendor
  Then user verify vendor list deleted
