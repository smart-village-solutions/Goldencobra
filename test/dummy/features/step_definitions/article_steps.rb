Given /^an article exists with the following attributes:$/ do |attrs_table|
  attrs = {}
  attrs_table.raw.each do |(attr, value)|
    sanitized_attr = attr.gsub(/\s+/, "-").underscore
    attrs[sanitized_attr.to_sym] = value
  end
  create("article", attrs)
end

Given /^an startarticle exists$/ do
  @article = create(:startpage)
  @article.mark_as_startpage!
end

When /^I have a secured site and I log in as a visitor$/ do
  Goldencobra::Setting.import_default_settings(::Rails.root + "../../config/settings.yml")
  @parent_article = create :article, :url_name => "seite1"
  @child_article = create :article, :parent_id => @parent_article.id
  @user = create :user
  @visitor = create :visitor
  @admin_role = create :role, :name => "Admin"
  @guest_role = create :role, :name => "Guest"
  @user.roles << @admin_role
  @visitor.roles << @guest_role
  visit "/admin/logout"
  visit "/admin/login"
  fill_in "user[email]", :with => @visitor.email
  fill_in "user[password]", :with => @visitor.password
  click_button "Login"
end

When /^a restricting permission exists$/ do
  Goldencobra::Permission.create(:action => "not_read", :subject_class => "Goldencobra::Article", :sorter_id => 200, :subject_id => @parent_article.id, :role_id => @guest_role.id)
end

When /^I change the page's title to "([^"]*)"$/ do |arg1|
  # Find the select box with the title tag.
  page.all(:css, 'select.metatag_names').instance_variable_get("@elements").each do |element|
    if element.value == 'Title Tag'

      # element[:name] should be this format: "article[metatags_attributes][1][name]"
      # Extract the id.
      element_id = element[:name].scan(/article\[(.*)\]\[(.*)\]\[(.*)\]/)[0][1]

      # Overwrite the current value in the title tag's value field.
      fill_in('article[metatags_attributes][' + element_id + '][value]', :with => arg1)

      break
    end
  end
end

Then /^the page title should contain "([^"]*)"$/ do |arg1|
  expect(page.title.include?(arg1)).to eq(true)
end


