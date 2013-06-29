class AddIndexForHappenedAtId < ActiveRecord::Migration
  def change
    add_index(:events, [ :happened_at, :id ] )
  end
end
