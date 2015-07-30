# encoding: utf-8

require 'bundler/setup'
require 'optparse'
require 'yaml'
require './lib/arguments_parser.rb'
require './lib/redmine_api.rb'

command, options = *ArgumentsParser.parse(ARGV)

config = YAML.load_file('config/redmine.yml').symbolize_keys!

api = RedmineAPI.new(config)

case command
  when :list_issues
  	issues = api.list_issues(options)
  	issues.each { |issue| puts "#{issue.id} - #{issue.subject} (#{issue.status.name})" }

  when :list_projects
  	projects = api.list_projects
  	projects.each { |project| puts "#{project.id} - #{project.name}" }

  when :track_time
  	api.track_time(options)
end
