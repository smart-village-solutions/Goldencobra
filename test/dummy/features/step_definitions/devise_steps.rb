Given /^that a confirmed admin exists$/ do
  @user = Factory.create(:admin_user)
  @user.roles << Factory.create(:admin_role)
end

Given /^that a confirmed guest exists$/ do
  @user = Factory.create(:guest_user)
  @user.roles << Factory.create(:guest_role)
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  visit "/admin/logout"
  visit "/admin/login"
  fill_in "user[email]", :with => email
  fill_in "user[password]", :with => password
  click_button "Login"
  page.should have_content('Signed in successfully.')
end
