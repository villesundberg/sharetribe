Before do
  Capybara.default_host = 'test.lvh.me'
  Capybara.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i
  Capybara.app_host = "http://test.lvh.me:#{9887 + ENV['TEST_ENV_NUMBER'].to_i}"
  @current_community = Community.find_by_domain("test")
end

Before('@javascript') do
  if ENV['PHANTOMJS']
    Capybara.current_driver = :webdriver_phantomjs
    page.driver.browser.manage.window.resize_to(1024, 768)

    # Store the reference to original confirm() function
    # (this might be mocked later)
    page.execute_script("window.__original_confirm = window.confirm")
  end
end

After('@javascript') do
  if ENV['PHANTOMJS']
    # Restore maybe mocked confirm()
    page.execute_script("window.confirm = window.__original_confirm")
  end
end

Before ('@subdomain2') do
  Capybara.default_host = 'test2.lvh.me'
  Capybara.app_host = "http://test2.lvh.me:#{Capybara.server_port}"
  @current_community = Community.find_by_domain("test2")
end

Before ('@no_subdomain') do
  Capybara.default_host = 'lvh.me'
  Capybara.app_host = "http://lvh.me:#{Capybara.server_port}"
end

After('@no_subdomain') do
  Capybara.default_host = 'test.lvh.me'
  Capybara.app_host = "http://test.lvh.me:#{Capybara.server_port}"
end

Before ('@www_subdomain') do
  Capybara.default_host = 'www.lvh.me'
  Capybara.app_host = "http://www.lvh.me:#{Capybara.server_port}"
end

After('@www_subdomain') do
  Capybara.default_host = 'test.lvh.me'
  Capybara.app_host = "http://test.lvh.me:#{Capybara.server_port}"
end

After do |scenario|
  if(scenario.failed?)
    FileUtils.mkdir_p 'tmp/screenshots'
    save_screenshot("tmp/screenshots/#{scenario.name}.png")
  end
end
