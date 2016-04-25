Rails.application.routes.draw do

  # The 'resources' method instructs Rails to create routes for CRUD actions,
  # replacing the 'get resource/action' sytax for each route.
  resources :posts

  resources :advertisements
  # The following route specication allows users to vist /about etc instead of
  # welcome/about etc
  get 'about' => 'welcome#about'

  get 'contact' => 'welcome#contact'

  get 'faq' => 'welcome#faq'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root 'welcome#index'

end
