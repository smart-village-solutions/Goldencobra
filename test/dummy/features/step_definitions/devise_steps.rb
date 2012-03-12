require 'Faker'

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

Given /^that "([^"]*)" users exist$/ do |arg1|
  arg1.to_i.times do
    password = "123456"#Time.now.to_s
    user = Factory.create(:user, firstname: "#{Faker::Name.first_name}",
                 lastname: "#{Faker::Name.last_name}",
                 email: "#{Faker::Internet.email}")
  end
end

Then /^I should see "([^"]*)" of the last created "([^"]*)"$/ do |arg1, arg2|
  page.should have_content(arg2.to_s.capitalize.constantize.last.send(arg1))
end
