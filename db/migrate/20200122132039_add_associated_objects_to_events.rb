class AddAssociatedObjectsToEvents < ActiveRecord::Migration[6.0]
  def change
    # Empty migration, because it failed halfway through and we fixed it in a prod console. We want Rails to record it as having run.
    # This emptying should be reverted once this has been deployed.
    puts "Hello!"
  end
end
