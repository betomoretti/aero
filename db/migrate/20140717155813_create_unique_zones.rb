class CreateUniqueZones < ActiveRecord::Migration
  def change
    create_table :unique_zones do |t|

      t.timestamps
    end
  end
end
