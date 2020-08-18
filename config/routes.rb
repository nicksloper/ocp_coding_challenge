Rails.application.routes.draw do
  resources :users

  resources :barcodes, except: [:show] do
    collection do
      post :generate
      post :import
    end
  end

  root to: "pages#root"
end
