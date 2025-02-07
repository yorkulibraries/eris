Eris::Application.routes.draw do


  resources :feeds

  resources :tagged_urls

  resources :services do
    post "sort_feeds", :on => :member
    get "preview", :on => :member
  end

  match "fetch/tagged_urls" => "tagged_urls#index", :format => :rss, :as => :tagged_urls_fetch
  match "fetch/:slug" => "services#fetch", :as => :fetch

  root :to => 'services#index'

  get "tags" => "tagged_urls#tags", :as => "tags"

  get "r" => "redirector#index", :as => "redirect"  
end
