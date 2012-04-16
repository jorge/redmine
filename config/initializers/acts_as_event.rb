require File.expand_path(File.join(File.dirname(__FILE__), '../../lib/acts_as_event/acts_as_event'))
ActiveRecord::Base.send(:include, Redmine::Acts::Event)
