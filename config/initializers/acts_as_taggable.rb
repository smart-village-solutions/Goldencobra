if ActiveRecord::Base.connection.table_exists?("taggings")
  ActsAsTaggableOn.remove_unused_tags = true
  ActsAsTaggableOn.strict_case_match = true
end

