class BasePage < PageFactory

  class << self

    def wrapper_elements
      element(:main_menu_el) { |b| b.link(title: "Main Menu") }
      element(:logout_el) { |b| b.button(value: "Logout") }
      element(:administration_el) { |b| b.link(title: "Administration") }

      action(:home) { |b| b.link(text: "Home").click }
      action(:main_menu) { |p| p.main_menu_el.click }
      action(:provide_feedback) { |b| b.link(title: "Provide Feedback").click }
      action(:administration) { |p| p.administration_el.click }
      action(:action_list) { |b| b.link(title: "Action List").click }
      action(:doc_search) { |b| b.link(title: "Document Search").click }

      value(:build) { |b| b.div(id: "build").text }
      value(:logged_in_user) { |b| b.div(id: "login-info").text[/(?<=:.).*$/] }

      value(:copyright) { |b| b.div(id: "footer-copyright").text }
      action(:acknowledgements) { |b| b.link(href: "acknowledgments.jsp").click }

      element(:loading) { |b| b.image(alt: "Loading...") }
    end

    def frame_element
      #element(:frm) { |b| b.frame(id: "iframeportlet") }
      element(:frm) { |b| b } #with iframe removed
    end

    def green_search_buttons
      action(:search) { |b| b.frm.button(text: "Search").click; b.loading.wait_while_present } # Persistent ID needed!
      action(:clear_values) { |b| b.frm.button(text: "Clear Values").click; b.loading.wait_while_present } # Persistent ID needed!
      action(:cancel) { |b| b.frm.button(text: "Cancel").click; b.loading.wait_while_present } # Persistent ID needed!
      action(:close) { |b| b.frm.button(text: "Close").click; b.loading.wait_while_present } # Persistent ID needed!
    end

    def validation_elements
      value(:error_header) { |b| b.frm.h3(id: "pageValidationHeader").text }
      value(:info_header) { |b| b.frm.h3(id: "pageValidationHeader").text }
      element(:error_list) { |b| b.frm.ul(id: "pageValidationList") }
      element(:info_list) { |b| b.frm.ul(id: "pageValidationList") }
      value(:first_error) { |b| b.error_list.link.text }
      value(:first_msg) { |b| b.info_list.li.text }
    end
  end


end
