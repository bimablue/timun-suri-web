@smoke-test
Feature: To test purchases in Jurnal

Background: User able to open jurnal login page
  Given user is on login page
  And login as "user_owner_1"

Scenario: User able to access create new purchases via top menu
  Then user is on create purchases invoice page via top menu

Scenario: User able to access create new purchases via side menu
  When user is on purchases page
  Then user is on create purchases invoice page via purchase page