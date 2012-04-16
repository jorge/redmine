require File.expand_path(File.join(File.dirname(__FILE__), '../../lib/acts_as_list/active_record/acts/list'))
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::List }
