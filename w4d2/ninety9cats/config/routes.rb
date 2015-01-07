Rails.application.routes.draw do
  resources :cats
  resources :cat_rentals
  post '/cat_rentals/:id/approve' => "cat_rentals#approve", as: "approve"
  post '/cat_rentals/:id/deny' => "cat_rentals#deny", as: "deny"
end
