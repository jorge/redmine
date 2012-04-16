require File.expand_path(File.join(File.dirname(__FILE__), '../../lib/acts_as_customizable/acts_as_customizable'))
ActiveRecord::Base.send(:include, Redmine::Acts::Customizable)
