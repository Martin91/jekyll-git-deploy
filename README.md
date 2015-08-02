jekyll-git-deploy
========
Executable commands to help you to deploy your [jekyll](http://jekyllrb.com/) blog through git push way conveniently!

### Getting Started
1. Install The Gem
  Install it through command line(recommended):
  ```sh
  gem install jekyll-git-deploy
  ```
  or, install it through the Gemfile:
  ```ruby
  gem 'jekyll-git-deploy', '~> 0.0.2'
```

2. Config Additional Keys In Your `_config.yml` file:
  ```yaml
  # #{site_root}/_config.yml
  deploy_repo: git@something.com:martin/jekyll-deploy-demo.git
  touch_file: Staticfile
  deploy_branch: github-pages
  deploy_remote_name: github
  ```
  More details about these configs will be described later.

3. Initialize The Destination
  Run the below command in the root of your jekyll site:
  ```sh
  jekyll-git-deploy init
  ```

4. Deploy The Site
  ```sh
  jekyll-git-deploy deploy
  ```

### More Details
#### 1. Supported Commands
Currently, `jekyll-git-deploy` supports its name as the main command and also two sub commands: `init` and `deploy`. They are mainly used to:

* `init`: Check and create destination directory for your deployment, and then check and initialize a git repo there
* `deploy`: Build the site using `jekyll build`, touch a specified file if necessary(some PaaS requires that a specifed name should be existed, they need that to detect a suitable running environment), create or checkout to deploy branch, commit changes and push them to specified repo and its branch.

#### 2. Supported Configs
`jekyll-git-deploy` dependent on five configs to work, the first one is `destination`, which is supported by jekyll itself already, here we use it to detect the target directory for generated site. The other four configs are:

| Config             | Purpose                                                     | Default Value | Required |
| --------           | --------                                                    | --------      | -------- |
| deploy_repo        | Specify the deploy target, should be a remote git repo      | NONE          | YES      |
| deploy_branch      | Specify the deploy target branch                            | pages         | NO       |
| deploy_remote_name | Specify the remote name added to git, work with deploy_repo | deploy        | NO       |
| touch_file         | Specify the file shoule be touched during a deployment      | Staticfile    | NO       |

To see source codes, visit [Source codes for configs](./lib/helpers/common_tasks.rb).

### Contribute Guides
This project is just in its initial stage, more features or patches are welcome.

1. Fork this repo;
2. Clone your forked repo to your local file system;
3. Check out to a new branch;
4. Write and test your codes;
5. Commit and push your changes to a remote branch in your forked repo;
6. Submit a new PR.
