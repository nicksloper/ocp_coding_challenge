Rails.application.routes.draw do
  resources :users

  resources :barcodes do
    collection do
      get :import
      post :upload
      post :generate
      post :destroy_all
      delete :destroy
    end
  end

  root to: "pages#root"
end
