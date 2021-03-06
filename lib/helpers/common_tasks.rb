module CommonTasks
  CONFIG_FILE = "_config.yml"

  CONFIG_DEFAULTS = {
    "destination" => "_site",
    "deploy_branch" => "pages",
    "deploy_remote_name" => "deploy",
    "touch_file" => "Staticfile"
  }

  REQUIRED_CONFIGS = %w(destination deploy_repo deploy_branch deploy_remote_name touch_file )

  def read_configs
    return @configs if @configs

    unless File.file?(CONFIG_FILE)
      raise "Can not find a config file, please check your current working directoy and ensure it is under the root of your jekyll site!".red
    end

    @configs = CONFIG_DEFAULTS.merge YAML.load_file("./#{CONFIG_FILE}")
  end

  def commit_newest_site
    message = "Genereted site at #{Time.now}"
    puts "\ncommit the site: #{message}".yellow
    `git add -A . && git commit -m "#{message}"`
  end

  def current_branch
    `git rev-parse --abbrev-ref HEAD`.strip
  end

  def checkout_target_branch(quiet = false)
    unless current_branch == deploy_branch
      puts "\nStart to checkout to deploy branch: #{deploy_branch}".yellow unless quiet
      if `git show-branch #{deploy_branch} 2> /dev/null`.empty?  # the deploy branch didn't exist
        `git checkout -b #{deploy_branch}`
      else
        `git checkout #{deploy_branch}`
      end
    end
  end

  def self.included(base)
    REQUIRED_CONFIGS.each do |method|
      define_method method do
        read_configs[method]
      end
    end
  end
end
