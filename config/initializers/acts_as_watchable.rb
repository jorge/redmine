# Include hook code here
require File.expand_path(File.join(File.dirname(__FILE__), '/../../lib/acts_as_watchable/acts_as_watchable'))
ActiveRecord::Base.send(:include, Redmine::Acts::Watchable)
