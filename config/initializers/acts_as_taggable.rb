Rails.application.config.to_prepare do
  if ActiveRecord::Base.connection.table_exists?("taggings")
    ActsAsTaggableOn.remove_unused_tags = true
    ActsAsTaggableOn.strict_case_match = true
  end
end
