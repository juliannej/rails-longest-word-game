Rails.application.routes.draw do
  root to: "game#game"
  get 'game', to: "game#game"
  get 'score', to: "game#score"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
