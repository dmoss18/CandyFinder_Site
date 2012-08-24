CandyFinder::Application.routes.draw do
  devise_for :users
  #devise_for :mobile, :controllers => { :sessions => "mobile/sessions" }

  #devise_scope :user do
  #  match "/mobile/login" => "devise/sessions#create"
  #end

  get "mobile/index"

  get "admin/index"

  get "admin/analytics"

  get "admin/top_ten_searches"

  get "map/map"

  get "searches/ingredient"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  #match 'mobile/login' => 'devise/sessions#create'
  match 'searches/sku' => 'searches#sku'
  match 'searches/name' => 'searches#name'
  match 'locations/from_region' => 'locations#from_region'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  match 'searches/sku/:id' => 'searches#sku', :as => :sku
  match 'searches/name/:id' => 'searches#name', :as => :name
  #match 'search/name/:id' => 'search#name', :as => :name
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :candies
  resources :locations
  resources :searches
  resources :annotations

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
  #match ':controller/:action'
  
end
