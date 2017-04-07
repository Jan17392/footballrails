Rails.application.routes.draw do

  mount ForestLiana::Engine => '/forest'
  ActiveAdmin.routes(self)

  devise_for :users

  root 'team_mappings#index'
  resources :matches


  scope '/api' do
    scope '/v1' do
      scope '/data' do
        resources :matches
        get '/recent_matches' => 'matches#recent_matches'
        get '/matches_without_odds' => 'matches#matches_without_odds'
        get '/assemble_training' => 'matches#assemble_training'
        get '/assemble_expert_performance' =>'matches#assemble_expert_performance'
        resources :predictions
        resources :odds
        resources :team_mappings
        get '/team' => 'teams#index'
        get '/team/:id' => 'teams#show'
        post '/team' => 'teams#create'
      end
    end
  end

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

end
