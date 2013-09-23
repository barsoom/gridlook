module ApplicationHelper
  def inspect_value(value)
    case value
    when Hash
      value.map { |k, v|
        content_tag(:p) do
          value = v.is_a?(String) ? v : v.inspect
          "#{k} = #{value}"
        end
      }.join("").html_safe
    when Array
      value.map { |v|
        content_tag(:p, v)
      }.join("").html_safe
    else
      value.inspect
    end
  end

  def data_if_present(data, title = nil)
    if data.present?
      (title ? content_tag(:h4, title) : "".html_safe) + inspect_value(data)
    end
  end

  def filtered?(params)
    params.values_at(:email, :name, :mailer_action).any?(&:present?)
  end

  def event_name_options(selected)
    options = [["All", nil]]
    options += Event.names
    options_for_select(options, selected)
  end

  def event_mailer_options(selected)
    options = [["All", nil]]
    options += Event.mailer_actions
    options_for_select(options, selected)
  end

  def prev_page_link(page)
    if page && page > 1
      link_to("← Newer", params.merge(page: page - 1))
    end
  end

  def next_page_link(records, page)
    link_to("Older →", params.merge(page: page + 1)) if records.any?
  end
end
