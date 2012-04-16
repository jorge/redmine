source :rubygems

gem "rails", "~> 3.2.0"
gem "rubytree"
gem "coderay", "~> 1.0.0"
gem "fastercsv", "~> 1.5.0", :platforms => [:mri_18, :mingw_18, :jruby]
gem "tzinfo", "~> 0.3.31"
gem "sqlite3"
gem "thin"
gem "prototype_legacy_helper",
    "0.0.0",
    :git => 'git://github.com/willbryant/prototype_legacy_helper.git'
    # :git => 'git://github.com/rails/prototype_legacy_helper.git'

# TODO rails-3.1: review the core changes to awesome_nested_set and decide on actions
gem "awesome_nested_set"
## TODO rails-3.1: review the core changes to open_id_authentication and decide on actions
gem "open_id_authentication",
    :git => 'git://github.com/ndbradley730/open_id_authentication.git',
    :branch => 'controllermethods_name_error'

gem "ruby-prof"
# gem "jquery-rails"
# gem "prototype-rails", :git => "https://github.com/rails/prototype-rails.git"
gem "prototype-rails"

gem 'therubyracer', :platforms => [:mri_18, :mri_19]
gem 'rails_autolink'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

# Optional gem for LDAP authentication
group :ldap do
  gem "net-ldap", "~> 0.3.1"
end

# Optional gem for OpenID authentication
group :openid do
  gem "ruby-openid", "~> 2.1.4", :require => "openid"
end

# Optional gem for exporting the gantt to a PNG file
group :rmagick do
  # RMagick 2 supports ruby 1.9
  # RMagick 1 would be fine for ruby 1.8 but Bundler does not support
  # different requirements for the same gem on different platforms
  gem "rmagick", ">= 2.0.0"
end

# Database gems
platforms :mri, :mingw do
  group :postgresql do
    gem "pg", "~> 0.9.0"
  end

  group :sqlite do
    gem "sqlite3"
  end
end

platforms :mri_18, :mingw_18 do
  group :mysql do
    gem "mysql"
  end
end

platforms :mri_19, :mingw_19 do
  group :mysql do
    gem "mysql2"
  end
end

platforms :jruby do
  gem "jruby-openssl"

  group :mysql do
    gem "activerecord-jdbcmysql-adapter"
  end

  group :postgresql do
    gem "activerecord-jdbcpostgresql-adapter"
  end

  group :sqlite do
    gem "activerecord-jdbcsqlite3-adapter"
  end
end

group :development do
  gem "rdoc", ">= 2.4.2"
  # gem 'thin'
  # gem 'autotest'
  # gem 'autotest-growl'
  # gem 'autotest-fsevent'
  # gem 'mynyml-redgreen'
  # gem 'rails-dev-tweaks', '~> 0.5.1'
  gem 'rails-dev-tweaks'
end

group :test do
  gem "test-unit"
  gem "shoulda", "~> 2.11"
  gem "object_daddy",
      :git => "git://github.com/awebneck/object_daddy.git",
      :branch => "rails-3-2-gem"
  gem "mocha"
end

# Load plugins' Gemfiles
Dir.glob File.expand_path("../vendor/plugins/*/Gemfile", __FILE__) do |file|
  puts "Loading #{file} ..." if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(file)
end
