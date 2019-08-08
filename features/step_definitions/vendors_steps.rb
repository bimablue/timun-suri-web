Given(/^user is on vendor page$/) do
    @app.vendors_index.load
    @app.vendors_index.wait_until_add_vendor_btn_visible 30
end

When(/^user delete "(.*)" vendor$/) do |type|
    @app.vendors_index.delete_vendor(type)
end


When(/^user verify vendor list deleted$/) do
    @app.vendors_index.verify_vendor_list_deleted
end

When(/^user search vendor$/) do
    vendor_name = @app.vendors_index.first_vendor_table_display_name.text
    @app.vendors_index.search_vendor_name(vendor_name)
end

When(/^user create "(.*)" new vendor via create purchase invoice$/) do |type|    
  p "User trying to create vendor"
  @app.purchases_new.create_new_vendor(type)
end

Then(/^user verify new vendor details as inputted$/) do
    @app.vendors_detail.verify_new_vendor_details @generate_vendor
end

Given(/^user edit vendor details$/) do
  @generate_vendor = faker_vendor_page_new
  @app.vendors_index.check_available_vendor_to_edit 
  if @app.vendors_detail.has_edit_vendor_btn?(visible: true)
    @app.vendors_detail.edit_vendor_btn.click
  else
    @app.vendors_new.fill_vendor_details @generate_vendor
    @app.vendors_detail.edit_vendor_btn.click
  end
  @app.vendors_edit.edit_vendor_details @generate_vendor
end

When("user create {int} new vendor") do |number|
    if @app.vendors_index.list_vendor_displayed?
      p "Vendor existed"
      @app.vendors_index.delete_vendor('all')
    end

    @app.vendors_new.load
    
    for i in 1..number
        @generate_vendor = faker_vendor_page_new
        @app.vendors_new.fill_vendor_details @generate_vendor
        
        if number > 1 && i != number
          @app.vendors_new.save_vendor_dropdown_btn.click
          @app.vendors_new.save_dropdown_list_create_new_option.click
          @app.vendors_new.save_add_and_new_vendor_detail_btn.click
        else
          @app.vendors_new.save_add_vendor_detail_btn.click
        end
    end
end

Given(/^user is on create purchase invoice page$/) do
  @app.purchases_new.load
  @app.purchases_new.wait_until_create_purchase_header_visible 30
end

