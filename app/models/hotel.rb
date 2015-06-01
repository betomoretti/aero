class Hotel < ActiveRecord::Base
  # include ActionController::UrlWriter
  belongs_to :destination
  has_one :exchange_rate
  has_many :seasons
  has_one :policy_child
  belongs_to :travel_operator
  has_many :fares_for_categories
end  