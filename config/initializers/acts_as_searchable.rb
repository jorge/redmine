require File.expand_path(File.join(File.dirname(__FILE__), '../../lib/acts_as_searchable/acts_as_searchable'))
ActiveRecord::Base.send(:include, Redmine::Acts::Searchable)
