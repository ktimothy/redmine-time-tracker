require 'optparse'

module ArgumentsParser
  def ArgumentsParser::ensure_single_command
    unless @command.nil?        
      puts @opts
      exit(1) 
    end
  end

  def ArgumentsParser::validate_command
    if @command.nil?        
      puts @opts
      exit(1) 
    end
  end

  def ArgumentsParser::parse(argv)
    options = {}

    opts = OptionParser.new
    opts.banner = "Usage: redmine_tracker.rb COMMAND [OPTIONS]\nYou must specify only one of the commands:"

    @command = nil
    @opts = opts
    
    # list projects command
    opts.on("--list_projects", "List projects") do
      ensure_single_command
      @command = :list_projects
    end

    
    # list issues command
    opts.on("--list_issues", "List issues") do
      opts.separator "Options for list issues command"

      ensure_single_command
      @command = :list_issues

      opts.on("--with_status=STATUS", String, "Specify status of tickets") do |status|
        options[:status] = status
      end

      opts.on("--project_id=PROJECT_ID", Integer, "List issues from specified project") do |project_id|
        options[:project_id] = project_id
      end
    end


    # track work time to issue command
    opts.on("--track_time", "Track time") do
      opts.separator "Options for tracking time command"
      
      ensure_single_command
      @command = :track_time

      options[:date] = Date.today.to_s(:db)
      options[:remote] = false

      opts.on("--to_issue=ISSUE_ID", Integer, "Set issue id to track time to (required)") do |issue_id|
        options[:issue_id] = issue_id
      end

      opts.on("--spent=SPENT_TIME", Float, "Specify spent time in hours (required)") do |spent_time|
        options[:spent_time] = spent_time
      end

      opts.on("--on=COMMENT", String, "A comment on activity (required)") do |comment|
        options[:comment] = comment
      end

      opts.on("--date=DATE", /\d{4}-\d\d-\d\d/, :OPTIONAL, "Set the date of job in YYYY-MM-DD format; defaults to current date") do |date|
        options[:date] = date
      end

      opts.on("-r", "--remote", "Use to track remote work") do |remote|
        options[:remote] = true
      end
    end
      

    opts.parse!

    validate_command

    [@command, options]
  end
end
