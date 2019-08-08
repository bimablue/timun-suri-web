class TopMenuSection < SitePrism::Section
    element :create_invoice_btn, '#menu-bar-invoice-create'
    element :create_purchase_btn, '#menu-bar-purchase-create'
    element :create_expense_btn, '#menu-bar-expense-create'
    element :user_name_label, :xpath, "//*[@class='user-name-label']"
    element :sleekr_label_dropdown, :xpath, "//*[@href='/' and text()='Sleekr']"
    element :data_migration_btn, "#data-migration"
    element :activity_time_line, "#activity-timeline-img"
    element :notif_btn, "#notif_id"
end