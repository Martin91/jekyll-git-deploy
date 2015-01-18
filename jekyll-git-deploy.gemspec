Gem::Specification.new do |s|
  s.name        = 'jekyll-git-deploy'
  s.version     = '0.0.1'
  s.date        = '2015-01-18'
  s.summary     = "Deploy jekyll site through git push"
  s.description = "Executable commands to help you to deploy your jekyll blog through git push way conveniently!"
  s.authors     = ["Martin Hong"]
  s.email       = 'hongzeqin@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = "https://github.com/Martin91/jekyll-git-deploy"
  s.executables = ['jekyll-git-deploy']
  s.license     = 'MIT'
end
