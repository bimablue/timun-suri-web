Given(/^user is on create purchases invoice page via top menu$/) do
  @app.purchases_new.top_menu.create_purchase_btn.click
  @app.purchases_new.wait_until_create_purchase_header_visible 30
  expect(@app.purchases_new).to be_displayed
end

Given(/^user is on purchases page$/) do
  @app.purchases.side_menu.purchase_btn.click
  expect(@app.purchases).to be_displayed
end

Given(/^user is on create purchases invoice page via purchase page$/) do
  @app.purchases.create_purchase_btn.click
  @app.purchases.purchase_invoice_btn.click
  @app.purchases_new.wait_until_create_purchase_header_visible 30
  expect(@app.purchases_new).to be_displayed
end