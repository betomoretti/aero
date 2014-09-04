class UniqueZone < ActiveRecord::Base
    has_many :unique_destinations, :dependent => :destroy

    def programs 
        Program.find(:all, :conditions => [ "unique_destination_id IN (?)", self.unique_destinations])
    end

end
