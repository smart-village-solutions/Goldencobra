Given /^an article exists with the following attributes:$/ do |attrs_table|
  attrs = {}
  attrs_table.raw.each do |(attr, value)|
    sanitized_attr = attr.gsub(/\s+/, "-").underscore
    attrs[sanitized_attr.to_sym] = value
  end
  Factory("article", attrs)
end

Given /^an startarticle exists$/ do
  @article = Factory.create(:startpage)
  @article.mark_as_startpage!
end

