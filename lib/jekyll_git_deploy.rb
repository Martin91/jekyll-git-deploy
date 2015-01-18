require 'yaml'
require 'support/ansi_colors'
require 'helpers/common_tasks'

module JekyllGitDeploy
  include CommonTasks

  # Initialize the deploy environment
  #
  def init
    configs = read_configs

    puts "Start to initialize the git repo at #{destination}".yellow
    unless deploy_repo && !deploy_repo.strip.empty?
      raise "You haven't specify any deploy repo in _config.yml file, the action can not continue!".red
    end

    file = File.open('.gitignore', 'r+')
    existed_line = file.readlines.select{|line| line.strip == destination}
    unless existed_line
      puts "\nadd #{destination} directory to .gitignore".yellow
      file.puts destination
    end
    file.close

    `mkdir -p #{Dir.pwd}/#{destination}`
    puts "\nruning `cd #{destination}`".yellow
    Dir.chdir destination do
      # Determine if there has been any git repo existed
      unless File.directory? ".git"
        `git init`
      end

      puts "\nStart to add remote url".yellow
      `git remote add #{deploy_remote_name} #{deploy_repo} 2> /dev/null`

      puts "\nCurrent git remotes:\n==========================".yellow
      puts `git remote -v`

      puts "\nFinished deploy initialization for the current site".green
    end
  end

  # Build and push(deploy) the newest generated site
  #
  def deploy
    puts "\nGenerating the newest site".yellow
    `jekyll build`

    # This step is only for coding.net
    puts "\nTouching Staticfile".yellow
    `touch #{destination}/Staticfile`

    puts "\nruning `cd #{destination}`".yellow
    Dir.chdir destination do
      if `git branch`.empty?  # Fully new git repo
        commit_newest_site

        puts "\nThis is a new git repo, creating new branch #{deploy_branch} now".yellow
        `git checkout -b #{deploy_branch} &> /dev/null && git merge #{current_branch}`
      else
        unless current_branch == deploy_branch
          puts "\nStart to checkout to deploy branch: #{deploy_branch}".yellow
          if `git show-branch #{deploy_branch} 2> /dev/null`.empty?  # the deploy branch didn't exist
            `git checkout -b #{deploy_branch}`
          else
            `git checkout #{deploy_branch}`
          end
        end

        commit_newest_site
      end

      puts "\nPushing newest generated site:".yellow
      `git push -u #{deploy_remote_name} #{deploy_branch}`

      puts "\nThe deploy is finished!".green
      `open "#{baseurl}"` if baseurl =~ /https?:\/\/\S+/
    end
  end
end