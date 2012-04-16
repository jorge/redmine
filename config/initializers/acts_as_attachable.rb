require File.expand_path(File.join(File.dirname(__FILE__), '../../lib/acts_as_attachable/acts_as_attachable'))
ActiveRecord::Base.send(:include, Redmine::Acts::Attachable)
