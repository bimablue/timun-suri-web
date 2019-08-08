require_relative "../sections/top_menu_section.rb"

class DashboardPage < SitePrism::Page
    set_url_matcher %r{.*}

    section :top_menu, TopMenuSection, "nav[class='navbar sm top-navbar']"
    element :dashboard_main_cotent, '#main-content'

    def go_to_main_content
      dashboard_main_cotent.click
    end
end