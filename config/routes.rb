Rails.application.routes.draw do
  post 'locations/notify' => 'locations#notify'
  get 'locations/reply' => 'locations#reply'
end
