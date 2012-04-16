require File.expand_path(File.join(File.dirname(__FILE__), '/../../lib/gravatar/gravatar'))
ActionView::Base.send :include, GravatarHelper::PublicMethods
