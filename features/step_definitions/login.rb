Given /^I am logged in as admin$/ do
  visit Login do |page|
    log_in "admin", "admin" unless logged_in_user == "admin"
  end
end