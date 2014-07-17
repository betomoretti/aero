class CreateUniqueDestinations < ActiveRecord::Migration
  def change
    create_table :unique_destinations do |t|

      t.timestamps
    end
  end
end
