require File.expand_path(File.join(File.dirname(__FILE__), '/../../lib/acts_as_activity_provider/acts_as_activity_provider'))
ActiveRecord::Base.send(:include, Redmine::Acts::ActivityProvider)
