class RemoveFooIndex < ActiveRecord::Migration
  def change
    # Someone must have added this manually to experiment.
    remove_index :events, name: "foo"
  end
end
