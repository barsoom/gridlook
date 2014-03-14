class AddTrackingOfTotalRowsForEvents < ActiveRecord::Migration
  def change
    execute <<-SQL
    CREATE TABLE rowcount (
      table_name  text NOT NULL,
      total_rows  bigint,
      PRIMARY KEY (table_name));

    SQL

    execute <<-SQL
    CREATE OR REPLACE FUNCTION count_rows()
    RETURNS TRIGGER AS
    '
    BEGIN
      IF TG_OP = ''INSERT'' THEN
        UPDATE rowcount
        SET total_rows = total_rows + 1
        WHERE table_name = TG_RELNAME;
      ELSIF TG_OP = ''DELETE'' THEN
        UPDATE rowcount
        SET total_rows = total_rows - 1
        WHERE table_name = TG_RELNAME;
      END IF;
    RETURN NULL;
    END;
    ' LANGUAGE plpgsql;
    SQL

    execute <<-SQL
    BEGIN;
    -- Make sure no rows can be added to events until we have finished
    LOCK TABLE events IN SHARE ROW EXCLUSIVE MODE;

    create TRIGGER countrows
    AFTER INSERT OR DELETE on events
    FOR EACH ROW EXECUTE PROCEDURE count_rows();

    -- Initialise the row count record
    DELETE FROM rowcount WHERE table_name = 'events';

    INSERT INTO rowcount (table_name, total_rows)
    VALUES  ('events',  (SELECT COUNT(*) FROM events));

    COMMIT;
    SQL
  end
end
