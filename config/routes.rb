Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root
  root :to => 'id_generator#index'

  get 'id_generator/index.html', to: 'id_generator#index'

end
