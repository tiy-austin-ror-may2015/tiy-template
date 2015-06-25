# Rails TIY template

# Add heroku procfile
file('Procfile',  "web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}")

# Add ruby version to gemfile
ruby_version = ask("What is your ruby version? ")
insert_into_file "Gemfile", "ruby '#{ruby_version}'", :after => "source 'https://rubygems.org'\n"

# Set timezone
insert_into_file "config/application.rb", "config.time_zone = 'Central Time (US & Canada)'",
  :after => "  class Application < Rails::Application\n"

# Add pg and puma gem
gem 'pg'
gem 'puma'

# Add Figaro (https://github.com/laserlemon/figaro)
gem 'figaro'

gem_group :production do
  gem 'rails_12factor'
end

gem_group :development, :test do
  gem 'pry' if yes?("Do you want to use Pry? ")
  gem 'faker'
end

# Bullet Gem  (https://github.com/flyerhzm/bullet)
gem 'bullet', group: :development
insert_into_file('config/environments/development.rb', """
  config.after_initialize do
    Bullet.enable = true
    Bullet.console = true
    Bullet.rails_logger = true
    #Bullet.add_footer = true
  end
""", after: "   # config.action_view.raise_on_missing_translations = true")

# Readme
run "rm README.rdoc"
run "touch README.md"

if yes?("Do you want to use Bootstrap? ")
  gem 'bootstrap-sass'
  run 'rm app/assets/stylesheets/application.css'
  file("app/assets/stylesheets/application.css.scss","""@import 'bootstrap-sprockets';
@import 'bootstrap';
//You need to now manually import every other scss file.""")
  insert_into_file("app/assets/javascripts/application.js", "//= require bootstrap-sprockets\n",
                   after: "//= require jquery\n")
end

if yes?("Do you want to use React? ")
  @react = true
  gem 'react-rails'
end

if yes?("Do you want to use bcrypt? ")
  gem 'bcrypt'
end


after_bundle do
  run 'rails g react:install' if @react
  run 'figaro install'
  puts "Be sure to put all your API keys, tokens, and other secrets inside of config/application.yml"
end

