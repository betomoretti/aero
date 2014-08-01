class UniqueDestination < ActiveRecord::Base
    belongs_to :unique_zone
    has_many :programs, :class_name => "Program", :foreign_key => "unique_destination_id"
end
