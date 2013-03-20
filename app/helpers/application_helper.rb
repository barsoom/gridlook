module ApplicationHelper
  def inspect_value(value)
    if value.is_a?(Hash)
      value.map { |k, v|
        content_tag(:p) do
          value = v.is_a?(String) ? v : v.inspect
          "#{k} = #{value}"
        end
      }.join("").html_safe
    else
      value.inspect
    end
  end

  def data_if_present(data, title)
    if data.present?
      content_tag(:h4, title) + inspect_value(data)
    end
  end
end
