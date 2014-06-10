require 'sidekiq/web'

DemocraticTravelers::Application.routes.draw do
  # Signin/out
  devise_for :users,  path: '',
                      path_names: {
                        sign_in: 'signin',
                        sign_out: 'signout',
                        sign_up: 'signup'
                      },
                      controllers: {
                        omniauth_callbacks: 'omniauth_callbacks',
                        registrations: 'registrations',
                        sessions: 'sessions'
                      }

  # Admin Stuff
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
    get '/admin' => 'admin#dashboard'
    namespace :admin do
      resources :locations, only: :create
      resources :experiences, only: [:toggle, :destroy] do
        post 'toggle'
      end
      resources :users
      resources :assets do
        post 'toggle_cover'
      end
      resources :states, only: :toggle do
        post 'toggle'
      end
    end
  end

  # API
  namespace :api, path: '', defaults: { format: :json },
                  constraints: { subdomain: 'api' } do
    namespace :v1 do
      resources :suggestions, only: :create
      resources :users, only: :show
      resources :experiences, except: [:new, :edit, :create] do
        member do
          post 'done'
          post 'upvote'
          post 'downvote'
        end
      end
      resources :locations, only: [:index, :show] do
        get 'current', on: :collection
      end
    end
  end

  # Map
  get '/map' => 'home#map'
  scope '/map' do
    resources :experiences, only: :show, path: ''
    resources :locations, only: :show
    resources :users, only: :show, path: 'ambassadors'
  end

  # Blog
  scope '/blog' do
    get 'archives', to: 'posts#index'
    resources :categories, path: 'departments'
    resources :posts, path: '', except: :index
    root to: 'categories#index', as: 'blog'
  end

  get '/feed' => 'posts#feed', as: :feed, defaults: { format: 'atom' }

  # Home/Static Pages
  post 'home/add_to_mailing_list'
  get '/about', to: 'home#about'
  get '/colophon', to: 'home#colophon'
  get '/sitemap', to: 'home#sitemap'
  root to: 'home#index'

  # Errors
  get '/404', to: 'errors#error_404'
  get '/500', to: 'errors#error_500'
end
