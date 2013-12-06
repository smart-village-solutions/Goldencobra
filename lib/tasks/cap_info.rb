#!/usr/bin/env ruby

# run in a cap-managed project to get pertinent variable info
# output in YAML

require 'rubygems'
require 'capistrano/configuration'
require 'pp'

config = Capistrano::Configuration.new
config.load("Capfile")
config.logger.level = 1   # -v

for stage in config.stages do
  stage_config = Capistrano::Configuration.new
  stage_config.load("Capfile")
  stage_config.logger.level = 1   # -v
  stage_config.find_and_execute_task(stage)
  puts "#{stage}:"
  puts "  gateway: #{stage_config[:gateway]}"
  puts "  user: #{stage_config[:ssh_options][:user]}"
  puts "  deploy_to: #{stage_config[:deploy_to]}"
  puts "  roles:"
  for role in stage_config.roles do
    puts "    #{role[0]}:"
    for server in role[1].servers do
      puts "      - #{server}"
    end
  end
end