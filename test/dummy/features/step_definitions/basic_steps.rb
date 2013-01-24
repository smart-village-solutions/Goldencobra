Given /^that I am not logged in$/ do
  visit "/admin/logout"
end

When /^I click on "([^\"]*)"$/ do |arg1|
  first(:link,arg1).click
end

When /^I visit url "([^\"]*)"$/ do |arg1|
  visit(arg1)
end

When /^I press "([^\"]*)"$/ do |arg1|
  first(:button,arg1).click
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |arg1, arg2|
  fill_in(arg1, :with => arg2)
end

Then /^I select "([^"]*)" within "([^"]*)"$/ do |arg1, arg2|
  first(arg2).select(arg1)
end


Then /^I fill in "([^"]*)" within "([^"]*)"$/ do |arg1, arg2|
  page.execute_script("$('#{arg2}').attr('value', '#{arg1}')")
end


Then /^I should see "([^\"]*)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^I should see "([^\"]*)" within "([^\"]*)"$/ do |arg1, content_position|
  find(content_position).should have_content(arg1)
end


Then /^I should not see "([^\"]*)"$/ do |arg1|
  page.should have_no_content(arg1)
end

Then /^I should not see "([^"]*)" within "([^"]*)"$/ do |arg1, content_position|
  find(content_position).should have_no_content(arg1)
end

Then /^the page should have content "([^"]*)"$/ do |arg1|
  first(arg1)
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^I click on "([^"]*)" within "([^"]*)"$/ do |arg1, arg2|
  find(arg2).click_link(arg1)
end

Then /^I check "([^"]*)"$/ do |arg1|
  check(arg1)
end

Given /^the following "([^"]*)" exist:$/ do |arg1, table|
  table.hashes.each do |data|
    create(arg1.singularize.to_sym ,data)
  end
end

Given /^default settings exists$/ do
  Goldencobra::Setting.import_default_settings(Goldencobra::Engine.root + "config/settings.yml")
end

Then /the text "([^"]*)"(?: within "([^"]*)")? should be visible/ do |text, nodes|
  scope = nodes ? nodes : '//*'
  page.find(:xpath, "#{scope}[contains(text(), '#{text}')]").visible?.should be_true
end

Then /the text "([^"]*)"(?: within "([^"]*)")? should not be visible/ do |text, nodes|
  scope = nodes ? nodes : '//*'
  page.find(:xpath, "#{scope}[contains(text(), '#{text}')]").visible?.should be_false
end

Then %r{^I should see "([^"]*)" inside ([^"].*)$} do |expected_text, named_element|
  sleep 15
  selector = element_for(named_element)
  within_frame selector do
    page.should have_content(expected_text)
  end
end

Then /^I should see "([^"]*)" within textfield "([^"]*)"$/ do |arg1, arg2|
  page.find_field("#{arg2}").value.should == "#{arg1}"
end

Then /^I should see the "([^"]*)" in this order:$/ do |selector, table|
  expected_order = table.raw
  actual_order = page.all(selector).collect(&:text)
  actual_order.should == expected_order.flatten
end

Given /^that basic Settings exists$/ do
  Goldencobra::Setting.import_default_settings(::Rails.root + "../../config/settings.yml")
end
