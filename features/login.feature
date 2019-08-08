@smoke-test
Feature: Login to Jurnal

Background: User able to open jurnal login page
  Given user is on login page

Scenario: Success login
  When login as "user_owner_1"
  Then user should be redirected to dashboard page

Scenario: User login with invalid email password
  When login as "user_owner_invalid_1"
  Then "login" message "invalid_username_password" displayed




