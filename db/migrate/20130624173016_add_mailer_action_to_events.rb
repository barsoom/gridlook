class AddMailerActionToEvents < ActiveRecord::Migration
  def up
    add_column :events, :mailer_action, :string
  end

  def down
  end
end
