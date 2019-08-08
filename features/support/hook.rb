Before do |scenario|
  Capybara.app_host = ENV['BASE_URL']
  Capybara.default_max_wait_time = 10
  # maintain backward compatible
  @wait = Selenium::WebDriver::Wait.new(timeout: 10, interval: 1, ignore: Selenium::WebDriver::Error::NoSuchElementError)
  @driver = page.driver
  @app = InitializePages.new
  @app_requirement = InitializeRequirement.new

  page.driver.browser.manage.window.resize_to(1366, 768)
  p "Scenario: #{scenario.name}"
end

After do |scenario|
  if scenario.failed?
    p 'test failed!'
    p "Getting screen shoot in session #{Capybara.session_name}"
    Capybara.using_session_with_screenshot(Capybara.session_name.to_s) do
      # screenshots will work and use the correct session
    end
  end

  Capybara.session_name = :default
  Capybara.current_session.driver.browser.manage.delete_all_cookies
  Capybara.reset_sessions!
end
