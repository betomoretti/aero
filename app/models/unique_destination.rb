class UniqueDestination < ActiveRecord::Base
    belongs_to :unique_zone
    has_many :programs
end
