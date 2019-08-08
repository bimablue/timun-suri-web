class LoginPage < SitePrism::Page
  include BaseHelper
  set_url "/en/users/login"
  set_url_matcher %r{/.*/users/login}

  element :user_email_field, '#user_email'
  element :user_password_field, '#user_password'
  element :submit_btn, :xpath, '//button[text()="Sign in"]'
  element :send_instruction_btn, :xpath, "//button[@name='button' and @type='submit']"
  element :already_have_account_btn, :xpath, "//button[@name='button' and @type='submit']/../following-sibling::*/p[1]/a[@href]"
  element :sign_up_btn, :xpath, "//button[@name='button' and @type='submit']/../following-sibling::*/p[2]/a[@href]"
  element :forgot_password_btn, :xpath, "//a[contains(@href,'/users/password/new')]"
  

  def login_as(user_detail)
    password = Base64.decode64(user_detail['password'])
    wait_until_user_email_field_visible 30
    user_email_field.set user_detail['email']
    user_password_field.set password
    submit_btn.click
    p "user success login using #{user_detail['email']}"
  end
end

