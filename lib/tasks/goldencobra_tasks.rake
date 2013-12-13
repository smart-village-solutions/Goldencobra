# encoding: utf-8

# desc "Explaining what the task does"
# task :goldencobra do
#   # Task goes here
# end

task :travis do
  ["rspec spec", "rake cucumber"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end
