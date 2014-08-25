class DropTriggerAndFunction < ActiveRecord::Migration
  def change
    if Rails.env.production?
      transaction do
        execute <<-SQL
        DROP TRIGGER IF EXISTS countrows ON events;
        DROP FUNCTION IF EXISTS count_rows();
        DROP TABLE IF EXISTS rowcount;
        SQL
      end
    end
  end
end
