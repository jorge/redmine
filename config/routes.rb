Redmine::Application.routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.

  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  match '/', :as => 'home', :controller => 'welcome', :action => 'index', :via => :get

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

  scope :controller => 'messages' do
    scope :via => :get do
      match '/boards/:board_id/topics/new', :action => 'new'
      match '/boards/:board_id/topics/:id', :action => 'show'
      match '/boards/:board_id/topics/:id/edit', :action => 'edit'
    end
    scope :via => :post do
      match '/boards/:board_id/topics/new', :action => 'new'
      match '/boards/:board_id/topics/preview', :action => 'preview'
      match '/boards/:board_id/topics/quote/:id', :action => 'quote'
      match '/boards/:board_id/topics/:id/replies', :action => 'reply'
      match '/boards/:board_id/topics/:id/edit', :action => 'edit'
      match '/boards/:board_id/topics/:id/destroy', :action => 'destroy'
    end
  end

  # Misc issue routes. TODO: move into resources
  match '/issues/auto_complete', :controller => 'auto_completes',
        :action => 'issues', :as => 'auto_complete_issues', :via => :get
  # TODO: would look nicer as /issues/:id/preview
  match '/issues/preview/new/:project_id', :controller => 'previews',
        :action => 'issue', :as => 'preview_new_issue'
  match '/issues/preview/edit/:id', :controller => 'previews',
        :action => 'issue', :as => 'preview_edit_issue'
  match '/issues/context_menu', :controller => 'context_menus',
        :action => 'issues', :as => 'issues_context_menu'

  scope :controller => 'journals' do
    match '/issues/changes', :action => 'index', :as => 'issue_changes'
    match '/issues/:id/quoted', :action => 'new', :as => 'quoted_issue',
          :id => /\d+/, :via => :post
    match '/journals/diff/:id', :action => 'diff',
          :id => /\d+/, :via => :get
    match '/journals/edit/:id', :action => 'edit',
          :id => /\d+/, :via => [:get, :post]
  end

  scope :controller => 'gantts', :action => 'show' do
    match '/projects/:project_id/issues/gantt(.:format)'
    match '/issues/gantt(.:format)'
  end

  scope :controller => 'calendars', :action => 'show' do
    match '/projects/:project_id/issues/calendar'
    match '/issues/calendar'
  end

  scope :controller => 'reports', :via => :get do
    match '/projects/:id/issues/report', :action => 'issue_report'
    match '/projects/:id/issues/report/:detail', :action => 'issue_report_details'
  end

  scope :controller => 'my' do
    match '/my/account', :action => 'account', :via => [:get, :post]
    match '/my/page', :action => 'page', :via => :get
    # Redirects to my/page
    match '/my', :action => 'index', :via => :get
    match '/my/reset_rss_key', :action => 'reset_rss_key', :via => :post
    match '/my/reset_api_key', :action => 'reset_api_key', :via => :post
    match '/my/password', :action => 'password', :via => [:get, :post]
    match '/my/page_layout', :action => 'page_layout', :via => :get
    match '/my/add_block', :action => 'add_block', :via => :post
    match '/my/remove_block', :action => 'remove_block', :via => :post
    match '/my/order_blocks', :action => 'order_blocks', :via => :post
  end

  scope :controller => 'users' do
    match '/users/:id/memberships/:membership_id', :as => 'user_membership',
          :action => 'edit_membership', :via => :put
    match '/users/:id/memberships/:membership_id',
          :action => 'destroy_membership', :via => :delete
    match '/users/:id/memberships', :as => 'user_memberships',
          :action => 'edit_membership', :via => :post
  end
  resources :users

  ## For nice "roadmap" in the url for the index action
  # map.connect 'projects/:project_id/roadmap', :controller => 'versions', :action => 'index'

  match '/news/preview', :as => 'preview_news',
        :controller => 'previews', :action => 'news'
  scope :controller => 'comments' do
    match '/news/:id/comments', :action => 'create', :via => :post
    match '/news/:id/comments/:comment_id', :action => 'destroy', :via => :delete
  end

  scope :controller => 'watchers' do
    match '/watchers/new', :action => 'new', :via => :get
    match '/watchers', :action => 'create', :via => :post
    match '/watchers/append', :action => 'append', :via => :post
    match '/watchers/destroy', :action => 'destroy', :via => :post
    match '/watchers/watch', :action => 'watch', :via => :post
    match '/watchers/unwatch', :action => 'unwatch', :via => :post
    match '/watchers/autocomplete_for_user',
          :action => 'autocomplete_for_user', :via => :get
  end

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

  resources :projects do
    member do
      get  'copy'
      post 'copy'
      get  'settings'
      post 'modules'
      post 'archive'
      post 'unarchive'
    end
    resource :enumerations, :controller => 'project_enumerations',
             :only => [:update, :destroy]
    # issue form update
    match 'issues/new', :as => 'issue_form', :controller => 'issues',
          :action => 'new', :via => [:post, :put]
    resources :issues, :only => [:index, :new, :create] do
      resources :time_entries, :controller => 'timelog' do
        collection do
          get 'report'
        end
      end
    end
    resources :files, :only => [:index, :new, :create]
    resources :versions, :shallow => true do
      collection do
        put 'close_completed'
      end
      member do
        post 'status_by'
      end
    end
    resources :news, :shallow => true
    resources :time_entries, :controller => 'timelog' do
      collection do
        get 'report'
      end
    end
    resources :queries, :only => [:new, :create]
    resources :issue_categories, :shallow => true
    resources :documents, :shallow => true do
      member do
        post 'add_attachment'
      end
    end
    resources :boards
    resources :repositories, :shallow => true, :except => [:index, :show] do
      member do
        get  'committers'
        post 'committers'
      end
    end
    resources :memberships, :shallow => true, :controller => 'members',
              :only => [:index, :show, :create, :update, :destroy] do
      collection do
        get 'autocomplete'
      end
    end
  end

  match '/news(.:format)', :controller => 'news', :action => 'index'

  resources :queries, :except => [:show]
  resources :issues do
    collection do
      get  'bulk_edit'
      post 'bulk_edit'
      post 'bulk_update'
    end
    resources :time_entries, :controller => 'timelog' do
      collection do
        get 'report'
      end
    end
    resources :relations, :shallow => true,
              :controller => 'issue_relations',
              :only => [:index, :show, :create, :destroy]
  end
  # Bulk deletion
  match '/issues', :controller => 'issues', :action => 'destroy',
        :via => :delete

  # map.connect '/time_entries/destroy',
  #             :controller => 'timelog', :action => 'destroy',
  #             :conditions => { :method => :delete }
  match '/time_entries/context_menu', :as => 'time_entries_context_menu',
        :controller => 'context_menus', :action => 'time_entries'

  resources :time_entries, :controller => 'timelog' do
    collection do
      get  'report'
      get  'bulk_edit'
      post 'bulk_update'
    end
  end

  scope :controller => 'activities', :action => 'index', :via => :get do
    match '/projects/:id/activity(.:format)'
    match '/activity(.:format)', :id => nil
  end

  scope :controller => 'repositories' do
    scope :via => :get do
      match '/projects/:id/repository/:repository_id/graph',
            :action => 'graph'
      match '/projects/:id/repository/:repository_id/statistics',
            :action => 'stats'

      match '/projects/:id/repository/graph',
            :action => 'graph'
      match '/projects/:id/repository/statistics',
            :action => 'stats'

      match '/projects/:id/repository/:repository_id/revisions(.:format)',
             :action => 'revisions'
      match '/projects/:id/repository/:repository_id/revisions/:rev',
             :action => 'revision'
      match '/projects/:id/repository/:repository_id/revisions/:rev/issues',
            :action => 'add_related_issue', :via => :post
      match '/projects/:id/repository/:repository_id/revisions/:rev/issues/:issue_id',
            :action => 'remove_related_issue', :via => :delete

      match '/projects/:id/repository/:repository_id/revisions/:rev/diff(.:format)(/*path)',
             :constraints => { :rev => /[a-z0-9\.\-_]+/ },
             :action => 'diff'
      match '/projects/:id/repository/:repository_id/revisions/:rev/raw(/*path)',
             :action => 'entry',
             :format => 'raw',
             :constraints => { :rev => /[a-z0-9\.\-_]+/ }
      match '/projects/:id/repository/:repository_id/revisions/:rev/:action(/*path)',
            :constraints => { 
              :action => /(browse|show|entry|changes|annotate|diff)/,
              :rev    => /[a-z0-9\.\-_]+/
            }

      match '/projects/:id/repository/:repository_id/raw(/*path)',
            :action => 'entry', :format => 'raw'
      match '/projects/:id/repository/:repository_id/:action(/*path)',
            :constraints => { 
              :action => /(browse|show|entry|changes|annotate|diff)/
            }

      match '/projects/:id/repository/revisions(.:format)',
             :action => 'revisions'
      match '/projects/:id/repository/revisions/:rev',
             :action => 'revision'
      match '/projects/:id/repository/revisions/:rev/issues',
            :action => 'add_related_issue', :via => :post
      match '/projects/:id/repository/revisions/:rev/issues/:issue_id',
            :action => 'remove_related_issue', :via => :delete
      match '/projects/:id/repository/revisions/:rev/diff(.:format)(/*path)',
             :constraints => { :rev => /[a-z0-9\.\-_]+/ },
             :action => 'diff'
      match '/projects/:id/repository/revisions/:rev/raw(/*path)',
             :action => 'entry',
             :format => 'raw',
             :constraints => { :rev => /[a-z0-9\.\-_]+/ }
      match '/projects/:id/repository/revisions/:rev/:action(/*path)',
            :constraints => { 
              :action => /(browse|show|entry|changes|annotate|diff)/,
              :rev    => /[a-z0-9\.\-_]+/
            }
      match '/projects/:id/repository/revisions/:rev/:action(/*path)',
            :action => 'show',
            :constraints => { 
              :path => /.+/
            }

      match '/projects/:id/repository/raw(/*path)',
            :action => 'entry', :format => 'raw'
      match '/projects/:id/repository/:action(/*path)',
            :constraints => { 
              :action => /(browse|entry|changes|annotate|diff)/
            }

      match '/projects/:id/repository/:repository_id',
             :action => 'show_root'
      match '/projects/:id/repository',
             :action => 'show_root'
    end
    scope :via => [:get, :post] do
      match '/projects/:id/repository/revision', :action => 'revision'
    end
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

  resources :groups do
    member do
      get 'autocomplete_for_user'
    end
  end
  scope :controller => 'groups' do
    match '/groups/:id/users', :as => 'group_users',
          :action => 'add_users',
          :constraints => { :id => /\d+/ }, :via => :post
    match '/groups/:id/users/:user_id', :as => 'group_user',
          :action => 'remove_user',
          :constraints => { :id => /\d+/ }, :via => :delete
    match '/groups/destroy_membership/:id',
          :action => 'destroy_membership',
          :constraints => { :id => /\d+/ }, :via => :post
    match '/groups/edit_membership/:id',
          :action => 'edit_membership',
          :constraints => { :id => /\d+/ }, :via => :post
  end

  resources :trackers, :except => :show
  resources :issue_statuses, :except => :show do
    collection do
      post 'update_issue_done_ratio'
    end
  end
  resources :custom_fields, :except => :show
  resources :roles, :except => :show do
    collection do
      get  'permissions'
      post 'permissions'
    end
  end
  resources :enumerations, :except => :show

  match '/search', :controller => 'search',
        :action => 'index', :via => :get

  match '/mail_handler', :controller => 'mail_handler',
        :action => 'index', :via => :post

  scope :controller => 'admin' do
    match '/admin', :action => 'index', :via => :get
    match '/admin/projects', :action => 'projects', :via => :get
    match '/admin/plugins', :action => 'plugins', :via => :get
    match '/admin/info', :action => 'info', :via => :get
    match '/admin/test_email', :action => 'test_email', :via => :get
    match '/admin/default_configuration', :action => 'default_configuration',
          :via => :post
  end

  resources :auth_sources do
    member do
      get 'test_connection'
    end
  end

  scope :controller => 'workflows' do
    match '/workflows', :action => 'index', :via => :get
    match '/workflows/edit', :action => 'edit', :via => [:get, :post]
    match '/workflows/copy', :action => 'copy', :via => [:get, :post]
  end

  scope :controller => 'settings' do
    match '/settings', :action => 'index', :via => :get
    match '/settings/edit', :action => 'edit', :via => [:get, :post]
    match '/settings/plugin/:id', :action => 'plugin', :via => [:get, :post]
  end

  scope :controller => 'sys' do
    match '/sys/projects(.:format)', :action => 'projects', :via => :get
    match '/sys/projects/:id/repository(.:format)',
          :action => 'create_project_repository', :via => :post
    match '/sys/fetch_changesets', :action => 'fetch_changesets',
          :via => :get
  end

  match '/uploads(.:format)', :controller => 'attachments',
        :action => 'upload', :via => :post

  match '/robots.txt', :controller => 'welcome',
        :action => 'robots', :via => :get

  # Used for OpenID
  root :controller => 'account', :action => 'login'
end
