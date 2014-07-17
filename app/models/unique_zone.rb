class UniqueZone < ActiveRecord::Base
    has_many :unique_destinations, :dependent => :destroy
end
