class AddUniqueArgsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :unique_args, :text
  end
end
