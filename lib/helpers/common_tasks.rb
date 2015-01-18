module CommonTasks
  CONFIG_FILE = "_config.yml"

  CONFIG_DEFAULTS = {
    "destination" => "_site",
    "deploy_branch" => "pages",
    "deploy_remote_name" => "deploy",
    "touch_file" => "Staticfile"
  }

  def read_configs
    return @configs if @configs

    unless File.file?(CONFIG_FILE)
      raise "Can not find a config file, please check your current working directoy and ensure it is under the root of your jekyll site!".red
    end

    @configs = CONFIG_DEFAULTS.merge YAML.load_file("./#{CONFIG_FILE}")
  end

  def method_missing(method, *args, &block)
    if read_configs.keys.include? (method.to_s)
      # Define the method firstly
      define_method method do
        read_configs[method.to_s]
      end

      # Then call new defined method
      send method
    else
      super
    end
  end

  def commit_newest_site
    message = "Genereted site at #{Time.now}"
    puts "\ncommit the site: #{message}".yellow
    `git add . && git commit -m "#{message}"`
  end

  def current_branch
    `git rev-parse --abbrev-ref HEAD`.strip
  end
end
