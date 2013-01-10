if ActsAsTaggableOn && ActsAsTaggableOn.method_defined?("strict_case_match")
  ActsAsTaggableOn.remove_unused_tags = true
  ActsAsTaggableOn.strict_case_match = true
end

