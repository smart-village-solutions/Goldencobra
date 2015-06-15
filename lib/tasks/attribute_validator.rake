namespace :attribute_validator do
  desc "Validate given attributes"
  task :url => :environment do
    model_name      = ENV['MODEL_NAME']
    attribute_name  = ENV['ATTRIBUTE_NAME']

    raise "No model name given! (rake attribute_validator:url MODEL_NAME=MyModel)" if model_name.blank?
    raise "No attribute name given! (rake attribute_validator:url ATTRIBUTE_NAME=MyModel)" if attribute_name.blank?

    results = Goldencobra::AttributeValidator.validate_url(model_name.to_s, attribute_name.to_s)

    file_name = File.join(Rails.root, "tmp", "attribute_validation_results.txt")
    file = File.open(file_name, "w+")
    file << (results.any? ? results : "No errors found.")
    file.close
    puts "Validation completed. See results at: #{file_name}"
  end
end
