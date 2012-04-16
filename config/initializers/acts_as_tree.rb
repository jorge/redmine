require File.expand_path(File.join(File.dirname(__FILE__), '../../lib/acts_as_tree/active_record/acts/tree'))
ActiveRecord::Base.send :include, ActiveRecord::Acts::Tree
