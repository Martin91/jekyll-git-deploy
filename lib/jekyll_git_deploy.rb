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

    file = File.open('.gitignore', 'a+')
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

      puts "Fetch remote codes...".yellow
      `git pull #{deploy_remote_name} #{deploy_branch}`

      puts "\nFinished deploy initialization for the current site".green
    end
  end

  # Build and push(deploy) the newest generated site
  #
  def deploy
    # Pull the newest deploy data
    Dir.chdir destination do
      unless `git branch`.empty?
        checkout_target_branch

        puts "Updating remote deployed versions...".green
        `git pull #{deploy_remote_name} #{deploy_branch}`
      end
    end

    puts "\nGenerating the newest site".yellow
    `jekyll build`

    # This step is only for sites requiring some special file to detect running environment
    unless destination.empty?
      puts "\nTouching Staticfile".yellow
      `touch #{destination}/Staticfile`
    end

    puts "\nruning `cd #{destination}`".yellow

    Dir.chdir destination do
      if `git branch`.empty?  # Fully new git repo
        commit_newest_site

        puts "\nThis is a new git repo, creating new branch #{deploy_branch} now".yellow
        `git checkout -b #{deploy_branch} &> /dev/null && git merge #{current_branch}`
      else
        checkout_target_branch
        commit_newest_site
      end

      puts "\nPushing newest generated site:".yellow
      push_result = `git push -u #{deploy_remote_name} #{deploy_branch} 2>&1`
      if push_result.include?("Updates were rejected because the remote contains work")
        print "Oops! It seems there are some updates exist in the remote repo so that your pushing has been rejected, do you want to force to update?[Y/N]".red
        if STDIN.gets.chomp.to_s.downcase == 'y'
          puts "Try to force to update remote repo...".yellow
          `git push -f #{deploy_remote_name} #{deploy_branch}`
        else
          puts "You have canceled the deploy process, you need to manually merge remote updates before deploy!".yellow
          exit
        end
      else
        puts push_result
      end

      puts "\nThe deploy is finished!".green
      baseurl = read_configs['baseurl'] || ""
      `open "#{baseurl}"` if baseurl =~ /https?:\/\/\S+/
    end
  end
end
