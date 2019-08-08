require_relative "../sections/side_menu_section.rb"

class PurchasesPage < SitePrism::Page
  include RSpec::Matchers
  set_url "/purchases"

  section :side_menu, SideMenuPage, "#side-menu"
  element :create_purchase_btn, :xpath, "//span[contains(text(),'Create New Purchase')]"
  element :purchase_invoice_btn, :xpath, "//a[text()='Purchase Invoice']"
  element :purchase_order_btn, :xpath, "//a[text()='Purchase Order']"
  element :purchase_quote_btn, :xpath, "//a[text()='Purchase Quote']"
end