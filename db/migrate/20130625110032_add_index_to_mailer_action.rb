class AddIndexToMailerAction < ActiveRecord::Migration
  def change
    add_index :events, :mailer_action
  end
end
