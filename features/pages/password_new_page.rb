class PasswordNewPage < SitePrism::Page
  set_url "/en/users/password/new"
  set_url_matcher %r{/.*/users/password/new}

  element :user_email_field, '#user_email'
  element :forgot_password_btn, :xpath, "//a[contains(@href,'/users/password/new')]"
  element :send_instruction_btn, :xpath, "//button[@name='button' and @type='submit']"
  element :already_have_account_btn, :xpath, "//button[@name='button' and @type='submit']/../following-sibling::*/p[1]/a[@href]"
  element :sign_up_btn, :xpath, "//button[@name='button' and @type='submit']/../following-sibling::*/p[2]/a[@href]"

  def send_forgot_password(email)
    user_email_field.set email
    send_instruction_btn.click
  end
end

