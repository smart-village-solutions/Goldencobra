Then /^I go to the startpage$/ do
  visit("/")
end

Given /^I am on the admin list of (.*)$/ do |name|
  visit("/admin/#{name}")
end

When /^I go to the admin list of (.*)$/ do |name|
  visit("/admin/#{name}")
end

Then /^I go to the article page "([^\"]*)"$/ do |arg1|
  visit("/#{arg1}")
end

Given /^I am on the admin dashboard$/ do
  visit("/admin")
end
