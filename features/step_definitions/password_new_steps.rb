When(/^user go to forgot password page$/) do
  step "user is on login page"
  @app.password_new.forgot_password_btn.click
  expect(@app.password_new).to be_displayed
  expect(@app.password_new.user_email_field.visible?).to be true
end

Given(/^user send forgot password instruction as "(.*)"/) do |user_email|
  @user_email = @app_requirement.login.load_crendential_details(user_email)
  @app.password_new.send_forgot_password(@user_email['email'])
end