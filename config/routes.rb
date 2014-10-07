Rails.application.routes.draw do

  root :to => 'unique#index'

  get ':controller/:action(/:id)'

  get 'search', to: 'unique#search'

  post 'unique/send_contact_mail'
  
  post 'unique/send_program_info', to: "unique#send_program_info"

  get  'unique/autocomplete'

end
