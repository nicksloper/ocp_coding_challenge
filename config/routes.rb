Rails.application.routes.draw do
  resources :users

  resources :barcodes do
    collection do
      post :import
    end
  end

  root to: "pages#root"
end
