class RegistersNewPage < SitePrism::Page
    include RSpec::Matchers
    include BaseHelper
    set_url "/registers/new"
    set_url_matcher %r{/registers/new}

    element :account_name_field, "#account_name"
    element :account_name_underline_text, :xpath, "//input[@id='account_name']/following-sibling::span"
    element :account_number_field, "#account_number"
    element :account_description_field, "#account_description"
    element :account_category_dropdown, "#select2-chosen-1"
    element :account_details_dropdown, "#select2-chosen-2"
    element :account_sub_details_sub_account_dropdown, "#select2-chosen-3"
    element :account_sub_details_header_account_dropdown, "#s2id_autogen5"
    element :account_tax_dropdown, "#select2-chosen-6"
    element :account_bank_name_dropdown, "#select2-chosen-4"
    element :account_start_balance_edit_btn, :xpath, "//a[@href='/conversion_balances/setup']"
    element :create_account_btn, "#create_button"
    element :cancel_account_btn, :xpath, "//a[@href='/registers/index']"
    element :account_setup_btn, "#learn-more"
    element :create_account_dropdown_btn, :xpath, "//input[@id='create_button']/following-sibling::button"
    element :create_account_dropdown_list_create_new_option, :xpath, "//td[contains(text(),'Create & New')]"
    element :create_account_and_new_btn, "#create_and_new_button"
    elements :list_detail_sub, '#select2-results-3 li div'

    def fill_account_details(value)
      @account_data = value
      select_category @account_data[:account_category]
      account_name_field.set @account_data[:account_name]
      account_description_field.set @account_data[:account_description]
      select_detail @account_data[:account_details]
      unless has_account_sub_details_header_account_dropdown?
        scroll_to(account_tax_dropdown)
        select_tax @account_data[:account_tax]
      end
    end

    def select_category(value)
      unless account_category_dropdown.text.eql? value
        select_dropdown account_category_dropdown, value
        expect(has_no_account_setup_btn?).to eq true 
      else
        select_bank @account_data[:account_bank_name]       
      end
      expect_account_number(value)
    end

    def select_detail(value, sub = {})
      select_dropdown account_details_dropdown, value
      if value == 'Header Account of :'
        expect(self).to have_account_sub_details_header_account_dropdown
        expect(self).to have_no_account_sub_details_sub_account_dropdown
        expect(self).to have_no_account_tax_dropdown
        # account_sub_details_header_account_dropdown.click
      elsif value == 'Sub Account of :'
        expect(self).to have_no_account_sub_details_header_account_dropdown
        expect(self).to have_account_sub_details_sub_account_dropdown
        if sub.empty?
          account_sub_details_sub_account_dropdown.click
          list_detail_sub.sample.click
        end
      else
        expect(self).to have_no_account_sub_details_header_account_dropdown
        expect(self).to have_no_account_sub_details_sub_account_dropdown
      end
    end

    def select_tax(value)
      unless value.nil?
        select_dropdown account_tax_dropdown, value
      end
    end

    def select_bank(value)
      unless value.nil?
        select_dropdown account_bank_name_dropdown, value
      end
    end

    def expect_account_number(value)
      if value.eql? "Credit Card"
        category_id = "9"
      else
        category_id = "3"
      end

      uri = URI("#{ENV['BASE_URL']}/accounts/get_header_and_child_candidate?category_id=#{category_id}&account_id=&currency_id=")
      req = Net::HTTP::Get.new(uri)
      cookie_name = Capybara.current_session.driver.browser.manage.all_cookies[0][:name]
      cookie_value = Capybara.current_session.driver.browser.manage.all_cookies[0][:value]
      req['Cookie'] = cookie_name + '=' + cookie_value
      
      Net::HTTP.start(uri.host, uri.port, 
        :use_ssl => uri.scheme == 'https', 
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http| 
        response = http.request(req) 
        parsed = JSON.parse(response.body)
        arr = []
        parsed["header_list"].each {|k|arr<<k["number"].strip}
        parsed["children_list"].each {|k|arr<<k["number"].strip}
        unless arr.empty?
          unless arr.all? {|x| x.include? '-'}
            number = []
            arr.each do |x|
              unless x.include? '-'
                number << x.to_i
              end
            end
            max_parsed = (number.max+1).to_s
          else
            first = []
            second = []
            arr.each do |x| 
              first << x.split('-')[0].strip
              second << x.split('-')[1].strip
            end
            first_max = first.max
            second_max = second.max
            duplicate_second = Hash.new(0)
            second.each { |number| duplicate_second[number] += 1 }
            max_parsed = first_max + '-' + (second_max.to_i+duplicate_second[second_max]).to_s
          end
          expect(account_number_field.value.strip).to be >= max_parsed
        else
          if value.eql? "Credit Card"
            expect(account_number_field.value).to include '2-'
          else
            expect(account_number_field.value).to include '1-'
          end
        end
      end
    end
end
