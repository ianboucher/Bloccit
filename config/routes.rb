Rails.application.routes.draw do

  # The 'resources' method instructs Rails to create routes for CRUD actions,
  # replacing the 'get resource/action' syntax for each route.

  # We pass 'resources :posts' to the 'resources :topics' block. This nests the
  # 'posts' routes under the topic route. Index is omitted as posts do not have
  # separeate index and are shown under their parent topis instead.
  resources :topics do
    resources :posts, except: [:index]
    resources :sponsored_posts, except: [:index]
  end

  # The 'only' hash key prevents Rails from creating unecessary routes
  resources :users, only: [:new, :create]

  resources :questions

  resources :advertisements

  # The following GET route specications allows users to vist /about etc instead
  # of welcome/about etc
  get 'about' => 'welcome#about'

  get 'contact' => 'welcome#contact'

  get 'faq' => 'welcome#faq'

  post 'users/confirm' => 'users#confirm'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root 'welcome#index'

end
