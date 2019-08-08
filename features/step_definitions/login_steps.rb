Given(/^user is on login page$/) do
  @app.login.load
  @wait.until {@app.login.displayed?}
  expect(@app.login).to be_displayed
  @app.login.user_email_field.visible?
  @app.login.user_password_field.visible?
end

When(/^login as "(.*)"$/) do |user_detail|
  @user = @app_requirement.login.load_crendential_details(user_detail)
  p "User will login using #{@user['email']}"
  @app.login.login_as @user
end

Then(/^user should be redirected to dashboard page$/) do
  expect(@app.dashboard).to be_displayed
  expect(@app.dashboard).to have_content(@user['name'])
end

Then(/^"(.*)" message "(.*)" displayed$/) do |current_page, message|
  assert_message(current_page, message)
end

Given "user login as {string}" do |user_name|
  steps %Q{
    Given user is on login page
    And login as "#{user_name}"
  }
end


