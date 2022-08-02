Rails.application.routes.draw do
  match '/custom_rest_search/search', :to => 'custom_rest_search#search', :via => :get
end
