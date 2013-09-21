RailsWanguo::Application.routes.draw do

  get 'imports/import_all'
  
  get "entrance/callback"

  get 'api/epmenus'

  get 'api/mistake_epmenus'

  match 'api/answer_question/:question_id/:answer'=>'api#answer_question',:as=>'api_answer_question'

  match 'api/mistake_questions_by_ep/:exampoint_id'=>'api#mistake_questions_by_ep',:as=>'api_mistake_questions_by_ep'

  match 'api/mistake_eps_by_epmenu/:epmenu_id'=>'api#mistake_eps_by_epmenu',:as=>'api_mistake_eps_by_epmenu'

  match "api/epmenu_questions/:id(/:limit)"=>"api#epmenu_questions",:as=>"api_epmenu_questions",:defaults=>{:limit=>15}

  match "api/rapid_questions/:volumn(/:limit)"=>"api#rapid_questions",:as=>"api_rapid_questions",:defaults=>{:limit=>15}

  match "api/ep_questions/:id"=>"api#ep_questions",:as=>"api_ep_questions"

  match "api/law_eps/:id"=>"api#law_eps",:as=>"api_law_eps"

  match "api/law(/:id)"=>"api#law",:as=>"api_law",:defaults=>{:id=>nil}

  match "api/freelaw(/:id)"=>"api#freelaw",:as=>"api_freelaw",:defaults=>{:id=>nil}

  resources :questions


  resources :imports


  resources :annexes


  resources :exampoints


  resources :laws


  resources :freelaws


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
