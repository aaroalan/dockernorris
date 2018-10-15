Rails.application.routes.draw do
  root to: 'jokes#index'
  get 'jokes/index'
end
