module ApplicationHelper
  def auto_field type, f, field, options = {}
    out = ''
    out += f.label field
    out += f.send(type, field, options)
    out += f.error_message_on field
    out.html_safe
  end

  def auto_text_field *args
    auto_field :text_field, *args
  end

  def auto_password_field *args
    auto_field :password_field, *args
  end

  def auto_text_area f, field, options = {}
    options.merge! :style => ''
    auto_field :text_area, f, field, options
  end

  def auto_select f, field, options = {}
    if options.empty?
      options = f.object.class.send(field.to_s.pluralize).to_select
    end
    auto_field :select, f, field, options
  end
end
