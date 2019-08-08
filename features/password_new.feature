Feature: To test reset password in Jurnal

Background: User able to open jurnal forgot password page
  Given user go to forgot password page

Scenario: User send instruction to reset password using valid account
  When user send forgot password instruction as "user_forgot_password"
  Then user is on login page
  And "login" message "send_email_reset_password" displayed

@smoke-test
Scenario: User send instruction to reset password using invalid account
  When user send forgot password instruction as "user_owner_invalid_1"
  Then "password" message "email_not_found" displayed 
