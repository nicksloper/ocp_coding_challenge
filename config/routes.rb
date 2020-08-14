Rails.application.routes.draw do
  resources :users

  resources :barcodes do
    collection do
      get :import
      post :generate
    end
  end

  root to: "pages#root"
end
