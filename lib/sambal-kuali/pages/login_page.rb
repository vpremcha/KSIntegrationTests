class Login < PageFactory

  page_url "#{$test_site}/portal.do?selectedTab=main"

  element(:username_field) { |b| b.text_field(:name=>"j_username") }
  element(:password_field) { |b| b.text_field(:name=>"j_password") }
  element(:login_button) { |b| b.button(:value=>"Login") }

  def login_with username, password
    username_field.set username
    password_field.set password
    login_button.click
  end

end