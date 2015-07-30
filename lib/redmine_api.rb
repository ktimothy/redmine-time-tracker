require 'active_resource'
require 'logger'

class RedmineAPI
  def initialize(config)
    @config = config

    BaseModel.initialize(config)

    # used for debugging AR queries
    #ActiveResource::Base.logger = Logger.new(STDOUT)

    # fetch current user
    @user = User.find(:current)
    puts "Hi, #{@user.firstname} #{@user.lastname}!"
  end

  def list_issues(options)
    @user.issues(options)
  end

  def list_projects
    Project.find(:all)
  end

  def track_time(options)
    params = {
        :issue_id => options[:issue_id],
        :hours => options[:spent_time],
        :comments => options[:comment],
        :spent_on => options[:date],
        
        # todo: allow user to specify activities and technologies on his own
        :activity_id => '12', # this is 'Dev' activity
        :subactivity_first => 'Coding',
        :technologies => ['[Dev] ruby'],
        :custom_fields => [CustomField.remote_work(options[:remote])]
    }

    new_time_entry = TimeEntry.new(params)
    new_time_entry.save
  end



  class BaseModel < ActiveResource::Base
    def self.initialize(config)
      self.site = config[:server]
      self.user = config[:username]
      self.password = config[:password]
      self.format = :xml
    end
  end

  # Issue model on the client side
  class Issue < BaseModel
    def time_entries(scope = :all)
      TimeEntry.find(scope, :params => { :issue_id => self.id })
    end
  end

  class User < BaseModel
    def issues(options = nil)
      params = { :assigned_to_id => self.id }

      if options
        params[:project_id] = options[:project_id] if options.has_key?(:project_id)
        
        status_id = nil || IssueStatus.find_by_name(options[:status]) if options.has_key?(:status)        
        params[:status_id] = status_id unless status_id.nil?
      end

      Issue.find(:all, :params => params).to_a
    end
  end

  private

  def find_issue_status_by_name(status_name)
    
  end

  class TimeEntry < BaseModel
    self.prefix = '/issues/:issue_id/'
  end

  class IssueStatus < BaseModel
    def self.find_by_name(status_name)
      statuses = find(:all)

      result = nil
      statuses.each do |status|
        result = status.id if status.name.downcase == status_name.downcase
      end

      result
    end
  end
  
  class IssueCategory < BaseModel
    self.prefix = '/projects/:project_id/'
  end
  
  class Project < BaseModel
    def categories
      IssueCategory.find(:all, :params => { :project_id => self.id })
    end
  end

  class CustomField < BaseModel
    def self.remote_work(remote = false)
      params = {
        :id => '40',
        :name => 'Удаленная работа',
        :value => remote ? '1' : '0'
      }

      CustomField.new(params)
    end
  end
end
