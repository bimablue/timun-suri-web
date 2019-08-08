module BaseHelper
    def mouse_hover(elmt)
      element = Capybara.page.driver.browser.find_element(:css, elmt)
      Capybara.page.driver.browser.mouse.move_to element
    end

    def fill_text(locator, data = {})
      locator.set data[:with]
      expect(locator.value).to eq data[:with]
    end

    def element_not_displayed?(locator)
      expect(locator).not_to be_displayed
    end

    def element_displayed?(locator, timeout=3)
      expected = locator =~ /^(xpath|css)/
      if expected.nil?
        locator.visible?
      else
        type_of_element = element_mapper(locator)
        type_of_element[:element_type].eql?('xpath')? find_xpath(type_of_element[:element_locator], timeout).visible? : find_css(type_of_element[:element_locator], timeout).visible?
      end
    rescue Exception => e
      false
    end

    def element_mapper(element)
      element_map = element.partition(':')
      type = element_map.first
      locator = element_map.last
      return{element_type: type,
        element_locator: locator
      }
    end

    def find_xpath(locator, timeout = 3)
      @short_wait = Selenium::WebDriver::Wait.new(:timeout => timeout, :interval => 0.2, :ignore => Selenium::WebDriver::Error::NoSuchElementError)
      @short_wait.until {find(:xpath, locator, wait: timeout)}
    end

    def find_css(locator, timeout = 3)
      @short_wait = Selenium::WebDriver::Wait.new(:timeout => timeout, :interval => 0.2, :ignore => Selenium::WebDriver::Error::NoSuchElementError)
      @short_wait.until {find(:css, locator, wait: timeout)}
    end

    def custom_fill(locator, text, timeout = 3)
      expected = locator =~ /^(xpath|css)/
      if expected.nil?
        while !locator.value.eql? text
          locator.set ''
          locator.set text
        end
      else
        type_of_element = element_mapper(locator)
        if type_of_element[:element_type].eql?('xpath')
          while !find_xpath(type_of_element[:element_locator], timeout).value.eql? text
            find_xpath(type_of_element[:element_locator], timeout).native.clear
            find_xpath(type_of_element[:element_locator], timeout).send_keys(text).value
          end
        else
          while !find_css(type_of_element[:element_locator], timeout).value.eql? text
            find_css(type_of_element[:element_locator], timeout).native.clear
            find_css(type_of_element[:element_locator], timeout).send_keys(text).value
          end
        end
      end
    end

    def custom_click(locator, timeout = 3)
      wait_for_ajax
      expected = locator =~ /^(xpath|css)/
      if expected.nil?
        @short_wait = Selenium::WebDriver::Wait.new(:timeout => timeout, :interval => 0.2, :ignore => Selenium::WebDriver::Error::NoSuchElementError)
        @short_wait.until {have_element?(locator)}
        locator.click
      else
        type_of_element = element_mapper(locator)
        type_of_element[:element_type].eql?('xpath')? find_xpath(type_of_element[:element_locator]).click : find_css(type_of_element[:element_locator]).click
      end
      wait_for_ajax
    rescue Exception => e
      raise e
    end

    def scroll_to(element)
      script = <<-JS
        arguments[0].scrollIntoView(true);
      JS
      expected = element =~ /^(xpath|css)/
      unless expected.nil?
        type_of_element = element_mapper(element)
      end
      if expected.nil? or type_of_element[:element_type].eql?('xpath')
        locator = find_xpath(element.path)
      else
        locator = find_css(type_of_element[:element_locator]).click
      end
      Capybara.current_session.driver.browser.execute_script(script, locator.native)
    end

    def select_dropdown(locator, value, timeout = 3)
      search_field_hidden = "xpath://*[@class='select2-search select2-search-hidden select2-offscreen']"
      search_field = "xpath://input[@aria-expanded = 'true' and starts-with(@id,'s2id_autogen')]|//input[starts-with(@aria-activedescendant,'select2-result') and (starts-with(@id,'s2id_autogen') or @class = 'select2-input')]"
      selected_value = "xpath:(//div[@role='option']/span[starts-with(text(),'#{value}')]|//div[@role='option' and contains(text(), '#{value}')])[1]"
      status = true
      unless value.nil?
        custom_click(locator)
        unless element_displayed? search_field_hidden, timeout
          custom_fill(search_field, value)
          if element_displayed? selected_value, timeout
            custom_click(selected_value)
            status = true
          else
            status = false
          end
        else
          status = false
        end
      else
        status = true
      end
      status
    end

    def select_label(name, options = {}, timeout = 3)
      el_search_hidden = "xpath://*[@class='select2-search select2-search-hidden select2-offscreen']"
      el = find('label', text: name)
      el_root = el.ancestor('.form-group')
      selected_value = "xpath:(//div[@role='option']/span[starts-with(text(),'#{options[:with]}')]|//div[@role='option' and contains(text(), '#{options[:with]}')])[1]"
      unless options.nil?
        el_root.find('a').click
        unless element_displayed? el_search_hidden, timeout
          el_root.find('input[aria-expanded="true"], input[aria-activedescendant^="select2-result"], input[class="select2-input"]').set "#{options[:with]}"
          if element_displayed? selected_value, timeout
            custom_click(selected_value)
            true
          else 
            false
          end
          true
        else
          false
        end
      else
        true
      end
    end

    def assert_message(current_page, message)
      page_notif = @app_requirement.message.load_notification(current_page)
      expect(page).to have_content(page_notif['message'])
    end

    def wait_for_ajax
      max_time = Capybara::Helpers.monotonic_time + Capybara.default_max_wait_time
      while Capybara::Helpers.monotonic_time < max_time
        finished = finished_all_ajax_requests?
        if finished
          break
        else
          sleep 0.1
        end
      end
      raise 'wait_for_ajax timeout' unless finished
    end

    def finished_all_ajax_requests?
      page.evaluate_script(<<~EOS
    ((typeof window.jQuery === 'undefined')
     || (typeof window.jQuery.active === 'undefined')
     || (window.jQuery.active === 0))
    && ((typeof window.injectedJQueryFromNode === 'undefined')
     || (typeof window.injectedJQueryFromNode.active === 'undefined')
     || (window.injectedJQueryFromNode.active === 0))
    && ((typeof window.httpClients === 'undefined')
     || (window.httpClients.every(function (client) { return (client.activeRequestCount === 0); })))
      EOS
      )
    end

    def select_date(element, date)
      unless date.eql?(DateTime.now.strftime "%d/%m/%Y")
        expected_date =  date.split('/')
        expected_day = expected_date[0].gsub(/^0/, "")
        expected_month = Date::ABBR_MONTHNAMES[expected_date[1].to_i]
        expected_year = expected_date[2].to_i
        month_year_element = "xpath://th[@colspan = '6' and @class = 'datepicker-switch']"
        prev_month_year_element = "xpath://th[@colspan = '6' and @class = 'datepicker-switch']/preceding-sibling::th"
        next_month_year_element = "xpath://th[@colspan = '6' and @class = 'datepicker-switch']/following-sibling::th"
        year_element = "xpath:(//th[@colspan = '5' and @class = 'datepicker-switch'])[1]"
        prev_year_element = "xpath:(//th[@colspan = '5' and @class = 'datepicker-switch'])[1]/preceding-sibling::th"
        next_year_element = "xpath:(//th[@colspan = '5' and @class = 'datepicker-switch'])[1]/following-sibling::th"
        day_element = "xpath://td[@class = 'day' and text()='#{expected_day}']"
        month_element = "xpath://span[text()='#{expected_month}']"
        custom_click(element)
        year_diff = expected_year - find(:xpath, month_year_element.split(":")[1]).text.split(" ")[1].to_i
        month_diff = expected_date[1].to_i - (DateTime.now.strftime "%m").to_i
        year_nav_button = year_diff < 0 ? prev_year_element : year_diff > 0 ? next_year_element : month_element
        month_nav_button = month_diff < 0 ? prev_month_year_element : month_diff > 0 ? next_month_year_element : day_element
        custom_click(month_year_element)
        if year_diff.eql? 0
          custom_click(year_nav_button)
        else
          for i in 1..year_diff.abs
            custom_click(year_nav_button)
          end
          custom_click(month_element)
        end
        custom_click(day_element)
      end
    end

    def take_screenshot(name_file, folder = 'report/screenshots')
      file = "#{folder}/#{name_file}.png"
      FileUtils.mkdir_p(folder) unless File.exist?(folder)
      Capybara.page.driver.browser.save_screenshot(file)
    end

    def take_screenshot_and_crop(name_file, css_element_crop, folder = 'report/screenshots/croped_files')
      file = "#{folder}/#{name_file}.png"
      FileUtils.mkdir_p(folder) unless File.exist?(folder)
      # scroll to element
      element = Capybara.page.driver.browser.find_element(:css, css_element_crop)
      element.location_once_scrolled_into_view

      # get location and size of element
      location = element.location
      size = element.size

      # take original screenshot
      take_screenshot('image_to_crop')

      # read original screenshot
      image = ChunkyPNG::Image.from_file('report/screenshots/image_to_crop.png')

      # get X, Y, width and height
      left = location['x']
      top = location['y']
      right = size['width']
      bottom = size['height']
      p [left, top, right, bottom]
      # crop original image and save
      # crop original image
      # if OS.mac?
      #   image.crop!(left * 2, top * 2, right * 2, bottom * 2)
      # else
      image.crop!(left, top, right, bottom)
      # end
      image.save(file)
    end

    def visual_match(actual, expected)
      imchr = Imatcher::Matcher.new threshold: 0, mode: :grayscale
      base_path = File.expand_path('.', Dir.pwd) + '/screenshots/'
      file_atual = File.join(base_path, 'current_images/') + actual + '.png'
      p "nah ini aktual #{file_atual}"
      file_baseline = File.join(base_path, 'baseline/') + expected + '.png'
      file_diff = File.join(base_path, 'diffs/') + actual + '_diff_' + expected + '.png'
      comparison = imchr.compare(file_atual, file_baseline)
      @score = comparison.score
      p @score
      comparison.difference_image.save(file_diff) if comparison.match? != true
      expect(comparison.match?).to be true
    end

    RSpec::Matchers.define :be_visual_match do |expected|
      match do |actual|
        # actual = full path file
        base_path = File.expand_path('.', Dir.pwd) + '/screenshots/'
        file_atual = File.expand_path('.', Dir.pwd) + "/report/screenshots/croped_files/#{actual}.png"
        # return false unless File.file?(actual)
        imchr = Imatcher::Matcher.new threshold: 0.05, mode: :grayscale
        file_baseline = File.join(base_path, 'baseline/') + expected + '.png'
        comparison = imchr.compare(file_atual, file_baseline)
        @score = comparison.score
        file_diff = File.join(base_path, 'diffs/') + expected + '_differences.png'
        comparison.difference_image.save(file_diff) if comparison.match? != true
        expect(comparison.match?).to be true
      end
      failure_message_for_should do |_actual|
        "Two images are expected to be match, but they are #{@score} different"
      end
    end
end

World(BaseHelper)