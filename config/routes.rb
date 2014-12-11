Rails.application.routes.draw do

  root :to => 'unique#index'

  get ':controller/:action(/:id)'

  get 'search/services', to: 'unique#search_services'
  get 'search/circuits', to: 'unique#search_circuits'
  get 'search/output_groups', to: 'unique#search_output_groups'

  post 'unique/send_contact_mail'
  get 'unique/send_services_mail'
  post 'unique/send_program_info', to: "unique#send_program_info"

  get  'unique/autocomplete'

end
