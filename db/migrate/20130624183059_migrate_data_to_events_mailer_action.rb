class MigrateDataToEventsMailerAction < ActiveRecord::Migration
  def up
    execute 'update events set mailer_action = array_to_string(regexp_matches(category, E\'\\\\w+#\\\\w+\'),\'\')'
  end

  def down
  end
end
