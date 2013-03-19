module ApplicationHelper
  def pretty_inspect(x)
    require "pp"
    x.pretty_inspect
  end

  def data_if_present(data, title)
    if data.present?
      content_tag(:h4, title) + pretty_inspect(data)
    end
  end
end
