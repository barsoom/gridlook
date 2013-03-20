class FixUniqueArgs < ActiveRecord::Migration
  def up
    Event.order("id ASC").find_each do |event|
      known_attributes = AttributeMapper::KNOWN_ATTRIBUTES.map(&:to_sym)
      data = event.data.symbolize_keys
      unique_args = data.except(*known_attributes)
      new_data = data.slice(*known_attributes)

      if event.arguments.present?
        unique_args[:arguments] = event.arguments
      end

      if unique_args.any?
        event.update_attributes!(
          unique_args: unique_args,
          data: new_data
        )
      end
    end
  end
end
