Redmine::Application.routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.

  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  map.home '', :controller => 'welcome', :conditions => {:method => :get}

  scope :controller => 'account' do
    match '/login', :action => 'login', :as => 'signin', :via => [:get, :post]
    match '/logout', :action => 'logout', :as => 'signout', :via => :get
    match '/account/register', :action => 'register', :via => [:get, :post]
    match '/account/lost_password', :action => 'lost_password', :via => [:get, :post]
    match '/account/activate', :action => 'activate', :via => :get
  end

  scope :controller => 'wikis' do
    match '/projects/:id/wiki', :action => 'edit', :via => :post
    match '/projects/:id/wiki/destroy', :action => 'destroy', :via => [:get, :post]
  end

  map.with_options :controller => 'messages' do |messages_routes|
    messages_routes.with_options :conditions => {:method => :get} do |messages_views|
      messages_views.connect 'boards/:board_id/topics/new', :action => 'new'
      messages_views.connect 'boards/:board_id/topics/:id', :action => 'show'
      messages_views.connect 'boards/:board_id/topics/:id/edit', :action => 'edit'
    end
    messages_routes.with_options :conditions => {:method => :post} do |messages_actions|
      messages_actions.connect 'boards/:board_id/topics/new', :action => 'new'
      messages_actions.connect 'boards/:board_id/topics/preview', :action => 'preview'
      messages_actions.connect 'boards/:board_id/topics/quote/:id', :action => 'quote'
      messages_actions.connect 'boards/:board_id/topics/:id/replies', :action => 'reply'
      messages_actions.connect 'boards/:board_id/topics/:id/edit', :action => 'edit'
      messages_actions.connect 'boards/:board_id/topics/:id/destroy', :action => 'destroy'
    end
  end

  # Misc issue routes. TODO: move into resources
  map.auto_complete_issues '/issues/auto_complete', :controller => 'auto_completes',
                           :action => 'issues', :conditions => { :method => :get }
  # TODO: would look nicer as /issues/:id/preview
  map.preview_issue '/issues/preview/:id', :controller => 'previews',
                    :action => 'issue'
  map.issues_context_menu '/issues/context_menu',
                          :controller => 'context_menus', :action => 'issues'

  map.issue_changes '/issues/changes', :controller => 'journals', :action => 'index'
  map.quoted_issue '/issues/:id/quoted', :controller => 'journals', :action => 'new',
                   :id => /\d+/, :conditions => { :method => :post }

  map.connect '/journals/diff/:id', :controller => 'journals', :action => 'diff',
              :id => /\d+/, :conditions => { :method => :get }
  map.connect '/journals/edit/:id', :controller => 'journals', :action => 'edit',
              :id => /\d+/, :conditions => { :method => [:get, :post] }

  scope :controller => 'gantts', :action => 'show' do
    match '/projects/:project_id/issues/gantt(.:format)'
    match '/issues/gantt(.:format)'
  end

  map.with_options :controller => 'calendars', :action => 'show' do |calendars_routes|
    calendars_routes.connect '/projects/:project_id/issues/calendar'
    calendars_routes.connect '/issues/calendar'
  end

  map.with_options :controller => 'reports', :conditions => {:method => :get} do |reports|
    reports.connect 'projects/:id/issues/report', :action => 'issue_report'
    reports.connect 'projects/:id/issues/report/:detail', :action => 'issue_report_details'
  end

  map.connect 'my/account', :controller => 'my', :action => 'account',
              :conditions => {:method => [:get, :post]}
  map.connect 'my/page', :controller => 'my', :action => 'page',
              :conditions => {:method => :get}
  # Redirects to my/page
  map.connect 'my', :controller => 'my', :action => 'index',
              :conditions => {:method => :get}
  map.connect 'my/reset_rss_key', :controller => 'my', :action => 'reset_rss_key',
              :conditions => {:method => :post}
  map.connect 'my/reset_api_key', :controller => 'my', :action => 'reset_api_key',
              :conditions => {:method => :post}
  map.connect 'my/password', :controller => 'my', :action => 'password',
              :conditions => {:method => [:get, :post]}
  map.connect 'my/page_layout', :controller => 'my', :action => 'page_layout',
              :conditions => {:method => :get}
  map.connect 'my/add_block', :controller => 'my', :action => 'add_block',
              :conditions => {:method => :post}
  map.connect 'my/remove_block', :controller => 'my', :action => 'remove_block',
              :conditions => {:method => :post}
  map.connect 'my/order_blocks', :controller => 'my', :action => 'order_blocks',
              :conditions => {:method => :post}

  map.with_options :controller => 'users' do |users|
    users.user_membership 'users/:id/memberships/:membership_id',
                          :action => 'edit_membership',
                          :conditions => {:method => :put}
    users.connect 'users/:id/memberships/:membership_id',
                  :action => 'destroy_membership',
                  :conditions => {:method => :delete}
    users.user_memberships 'users/:id/memberships',
                           :action => 'edit_membership',
                           :conditions => {:method => :post}
  end
  map.resources :users

  # For nice "roadmap" in the url for the index action
  map.connect 'projects/:project_id/roadmap', :controller => 'versions', :action => 'index'

  map.preview_news '/news/preview', :controller => 'previews', :action => 'news'
  map.connect 'news/:id/comments', :controller => 'comments',
              :action => 'create', :conditions => {:method => :post}
  map.connect 'news/:id/comments/:comment_id', :controller => 'comments',
              :action => 'destroy', :conditions => {:method => :delete}

  map.connect 'watchers/new', :controller=> 'watchers', :action => 'new',
              :conditions => {:method => :get}
  map.connect 'watchers', :controller=> 'watchers', :action => 'create',
              :conditions => {:method => :post}
  map.connect 'watchers/destroy', :controller=> 'watchers', :action => 'destroy',
              :conditions => {:method => :post}
  map.connect 'watchers/watch', :controller=> 'watchers', :action => 'watch',
              :conditions => {:method => :post}
  map.connect 'watchers/unwatch', :controller=> 'watchers', :action => 'unwatch',
              :conditions => {:method => :post}
  map.connect 'watchers/autocomplete_for_user', :controller=> 'watchers', :action => 'autocomplete_for_user',
              :conditions => {:method => :get}

  # TODO: port to be part of the resources route(s)
  scope :via => :get do
    match '/projects/:id/settings/:tab', :controller => 'projects', :action => 'settings'
    match '/projects/:project_id/issues/:copy_from/copy', :controller => 'issues', :action => 'new'
  end

  scope :controller => 'wiki' do
    match '/projects/:project_id/wiki/index',
          :action => 'index', :via => :get
    match '/projects/:project_id/wiki/date_index',
          :action => 'date_index', :via => :get
    match '/projects/:project_id/wiki/export',
          :action => 'export', :via => :get
    match '/projects/:project_id/wiki/(:id)',
          :as => 'wiki_start_page', :action => 'show', :via => :get
    match '/projects/:project_id/wiki/:id/diff(/:version(/vs/:version_from))',
          :as => 'wiki_diff', :action => 'diff'
    match '/projects/:project_id/wiki/:id/annotate(/:version)',
          :as => 'wiki_annotate', :action => 'annotate'
  end
  scope '/projects/:project_id' do
    resources :wiki, :except => [:new, :create, :index] do
      member do
        match :rename, :via => [:get, :post]
        get :history
        match :preview
        post :protect
        post :add_attachment
      end
    end
  end

  map.resources :projects, :member => {
    :copy => [:get, :post],
    :settings => :get,
    :modules => :post,
    :archive => :post,
    :unarchive => :post
  } do |project|
    project.resource :enumerations, :controller => 'project_enumerations',
                     :only => [:update, :destroy]
    # issue form update
    project.issue_form 'issues/new', :controller => 'issues',
                       :action => 'new', :conditions => {:method => [:post, :put]}
    project.resources :issues, :only => [:index, :new, :create] do |issues|
      issues.resources :time_entries, :controller => 'timelog',
                       :collection => {:report => :get}
    end

    project.resources :files, :only => [:index, :new, :create]
    project.resources :versions, :shallow => true,
                      :collection => {:close_completed => :put},
                      :member => {:status_by => :post}
    project.resources :news, :shallow => true
    project.resources :time_entries, :controller => 'timelog',
                      :collection => {:report => :get}
    project.resources :queries, :only => [:new, :create]
    project.resources :issue_categories, :shallow => true
    project.resources :documents, :shallow => true, :member => {:add_attachment => :post}
    project.resources :boards
    project.resources :repositories, :shallow => true, :except => [:index, :show],
                      :member => {:committers => [:get, :post]}
    project.resources :memberships, :shallow => true, :controller => 'members',
                      :only => [:index, :show, :create, :update, :destroy],
                      :collection => {:autocomplete => :get}
  end

  match '/news(.:format)', :controller => 'news', :action => 'index'

  map.resources :queries, :except => [:show]
  map.resources :issues,
                :collection => {:bulk_edit => [:get, :post], :bulk_update => :post} do |issues|
    issues.resources :time_entries, :controller => 'timelog',
                     :collection => {:report => :get}
    issues.resources :relations, :shallow => true,
                     :controller => 'issue_relations',
                     :only => [:index, :show, :create, :destroy]
  end
  # Bulk deletion
  map.connect '/issues', :controller => 'issues', :action => 'destroy',
              :conditions => {:method => :delete}

  map.connect '/time_entries/destroy',
              :controller => 'timelog', :action => 'destroy',
              :conditions => { :method => :delete }
  map.time_entries_context_menu '/time_entries/context_menu',
                   :controller => 'context_menus', :action => 'time_entries'

  map.resources :time_entries, :controller => 'timelog',
                :collection => {:report => :get, :bulk_edit => :get, :bulk_update => :post}

  scope :controller => 'activities', :action => 'index', :via => :get do
    match '/projects/:id/activity(.:format)'
    match '/activity(.:format)', :id => nil
  end

  map.with_options :controller => 'repositories' do |repositories|
    repositories.with_options :conditions => {:method => :get} do |repository_views|
      repository_views.connect 'projects/:id/repository',
                               :action => 'show'

      repository_views.connect 'projects/:id/repository/:repository_id/statistics',
                               :action => 'stats'
      repository_views.connect 'projects/:id/repository/:repository_id/graph',
                               :action => 'graph'

      repository_views.connect 'projects/:id/repository/statistics',
                               :action => 'stats'
      repository_views.connect 'projects/:id/repository/graph',
                               :action => 'graph'

      repository_views.connect 'projects/:id/repository/:repository_id/revisions',
                               :action => 'revisions'
      repository_views.connect 'projects/:id/repository/:repository_id/revisions.:format',
                               :action => 'revisions'
      repository_views.connect 'projects/:id/repository/:repository_id/revisions/:rev',
                               :action => 'revision'
      repository_views.connect 'projects/:id/repository/:repository_id/revisions/:rev/issues',
                                :action => 'add_related_issue', :conditions => {:method => :post}
      repository_views.connect 'projects/:id/repository/:repository_id/revisions/:rev/issues/:issue_id',
                                :action => 'remove_related_issue', :conditions => {:method => :delete}
      repository_views.connect 'projects/:id/repository/:repository_id/revisions/:rev/diff',
                               :action => 'diff'
      repository_views.connect 'projects/:id/repository/:repository_id/revisions/:rev/diff.:format',
                               :action => 'diff'
      repository_views.connect 'projects/:id/repository/:repository_id/revisions/:rev/raw/*path',
                               :action => 'entry', :format => 'raw'
      repository_views.connect 'projects/:id/repository/:repository_id/revisions/:rev/:action/*path',
                               :requirements => { 
                                   :action => /(browse|show|entry|changes|annotate|diff)/,
                                   :rev    => /[a-z0-9\.\-_]+/
                                 }
      repository_views.connect 'projects/:id/repository/:repository_id/raw/*path',
                               :action => 'entry', :format => 'raw'
      repository_views.connect 'projects/:id/repository/:repository_id/:action/*path',
                               :requirements => { :action => /(browse|show|entry|changes|annotate|diff)/ }

      repository_views.connect 'projects/:id/repository/revisions',
                               :action => 'revisions'
      repository_views.connect 'projects/:id/repository/revisions.:format',
                               :action => 'revisions'
      repository_views.connect 'projects/:id/repository/revisions/:rev',
                               :action => 'revision'
      repository_views.connect 'projects/:id/repository/revisions/:rev/issues',
                                :action => 'add_related_issue', :conditions => {:method => :post}
      repository_views.connect 'projects/:id/repository/revisions/:rev/issues/:issue_id',
                                :action => 'remove_related_issue', :conditions => {:method => :delete}
      repository_views.connect 'projects/:id/repository/revisions/:rev/diff',
                               :action => 'diff'
      repository_views.connect 'projects/:id/repository/revisions/:rev/diff.:format',
                               :action => 'diff'
      repository_views.connect 'projects/:id/repository/revisions/:rev/raw/*path',
                               :action => 'entry', :format => 'raw'
      repository_views.connect 'projects/:id/repository/revisions/:rev/:action/*path',
                               :requirements => { 
                                   :action => /(browse|show|entry|changes|annotate|diff)/,
                                   :rev    => /[a-z0-9\.\-_]+/
                                 }
      repository_views.connect 'projects/:id/repository/raw/*path',
                               :action => 'entry', :format => 'raw'
      repository_views.connect 'projects/:id/repository/:action/*path',
                               :requirements => { :action => /(browse|show|entry|changes|annotate|diff)/ }

      repository_views.connect 'projects/:id/repository/:repository_id',
                               :action => 'show'
    end

    repositories.connect 'projects/:id/repository/revision',
                         :action => 'revision',
                         :conditions => {:method => [:get, :post]}
  end

  # additional routes for having the file name at the end of url
  scope :controller => 'attachments', :via => :get do
    match '/attachments/:id/:filename', :action => 'show',
          :constraints => { :id => /\d+/, :filename => /.*/ }
    match '/attachments/:id(.:format)', :action => 'show', :id => /\d+/
    match '/attachments/download/:id/:filename', :action => 'download',
          :constraints => { :id => /\d+/, :filename => /.*/ }
    match '/attachments/download/:id', :action => 'download',
          :constraints => { :id => /\d+/ }
  end
  resources :attachments, :only => [:show, :destroy]

  map.resources :groups, :member => {:autocomplete_for_user => :get}
  map.group_users 'groups/:id/users', :controller => 'groups',
                  :action => 'add_users', :id => /\d+/,
                  :conditions => {:method => :post}
  map.group_user  'groups/:id/users/:user_id', :controller => 'groups',
                  :action => 'remove_user', :id => /\d+/,
                  :conditions => {:method => :delete}
  map.connect 'groups/destroy_membership/:id', :controller => 'groups',
              :action => 'destroy_membership', :id => /\d+/,
              :conditions => {:method => :post}
  map.connect 'groups/edit_membership/:id', :controller => 'groups',
              :action => 'edit_membership', :id => /\d+/,
              :conditions => {:method => :post}

  map.resources :trackers, :except => :show
  map.resources :issue_statuses, :except => :show, :collection => {:update_issue_done_ratio => :post}
  map.resources :custom_fields, :except => :show
  map.resources :roles, :except => :show, :collection => {:permissions => [:get, :post]}
  map.resources :enumerations, :except => :show

  map.connect 'search', :controller => 'search', :action => 'index', :conditions => {:method => :get}

  map.connect 'mail_handler', :controller => 'mail_handler',
              :action => 'index', :conditions => {:method => :post}

  map.connect 'admin', :controller => 'admin', :action => 'index',
              :conditions => {:method => :get}
  map.connect 'admin/projects', :controller => 'admin', :action => 'projects',
              :conditions => {:method => :get}
  map.connect 'admin/plugins', :controller => 'admin', :action => 'plugins',
              :conditions => {:method => :get}
  map.connect 'admin/info', :controller => 'admin', :action => 'info',
              :conditions => {:method => :get}
  map.connect 'admin/test_email', :controller => 'admin', :action => 'test_email',
              :conditions => {:method => :get}
  map.connect 'admin/default_configuration', :controller => 'admin',
              :action => 'default_configuration', :conditions => {:method => :post}

  # Used by AuthSourcesControllerTest
  # TODO : refactor *AuthSourcesController to remove these routes
  map.connect 'auth_sources', :controller => 'auth_sources',
              :action => 'index', :conditions => {:method => :get}
  map.connect 'auth_sources/new', :controller => 'auth_sources',
              :action => 'new', :conditions => {:method => :get}
  map.connect 'auth_sources/create', :controller => 'auth_sources',
              :action => 'create', :conditions => {:method => :post}
  map.connect 'auth_sources/destroy/:id', :controller => 'auth_sources',
              :action => 'destroy', :id => /\d+/, :conditions => {:method => :post}
  map.connect 'auth_sources/test_connection/:id', :controller => 'auth_sources',
              :action => 'test_connection', :conditions => {:method => :get}
  map.connect 'auth_sources/edit/:id', :controller => 'auth_sources',
              :action => 'edit', :id => /\d+/, :conditions => {:method => :get}
  map.connect 'auth_sources/update/:id', :controller => 'auth_sources',
              :action => 'update', :id => /\d+/, :conditions => {:method => :post}

  map.connect 'ldap_auth_sources', :controller => 'ldap_auth_sources',
              :action => 'index', :conditions => {:method => :get}
  map.connect 'ldap_auth_sources/new', :controller => 'ldap_auth_sources',
              :action => 'new', :conditions => {:method => :get}
  map.connect 'ldap_auth_sources/create', :controller => 'ldap_auth_sources',
              :action => 'create', :conditions => {:method => :post}
  map.connect 'ldap_auth_sources/destroy/:id', :controller => 'ldap_auth_sources',
              :action => 'destroy', :id => /\d+/, :conditions => {:method => :post}
  map.connect 'ldap_auth_sources/test_connection/:id', :controller => 'ldap_auth_sources',
              :action => 'test_connection', :conditions => {:method => :get}
  map.connect 'ldap_auth_sources/edit/:id', :controller => 'ldap_auth_sources',
              :action => 'edit', :id => /\d+/, :conditions => {:method => :get}
  map.connect 'ldap_auth_sources/update/:id', :controller => 'ldap_auth_sources',
              :action => 'update', :id => /\d+/, :conditions => {:method => :post}

  map.connect 'workflows', :controller => 'workflows',
              :action => 'index', :conditions => {:method => :get}
  map.connect 'workflows/edit', :controller => 'workflows',
              :action => 'edit', :conditions => {:method => [:get, :post]}
  map.connect 'workflows/copy', :controller => 'workflows',
              :action => 'copy', :conditions => {:method => [:get, :post]}

  map.connect 'settings', :controller => 'settings',
              :action => 'index', :conditions => {:method => :get}
  map.connect 'settings/edit', :controller => 'settings',
              :action => 'edit', :conditions => {:method => [:get, :post]}
  map.connect 'settings/plugin/:id', :controller => 'settings',
              :action => 'plugin', :conditions => {:method => [:get, :post]}

  map.with_options :controller => 'sys' do |sys|
    sys.connect 'sys/projects.:format',
                :action => 'projects',
                :conditions => {:method => :get}
    sys.connect 'sys/projects/:id/repository.:format',
                :action => 'create_project_repository',
                :conditions => {:method => :post}
    sys.connect 'sys/fetch_changesets',
                :action => 'fetch_changesets',
                :conditions => {:method => :get}
  end

  map.connect 'robots.txt', :controller => 'welcome',
              :action => 'robots', :conditions => {:method => :get}

  # Used for OpenID
  map.root :controller => 'account', :action => 'login'
end
