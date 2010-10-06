module ApplicationHelper
  def auto_text_field f, field
    out = ''
    out += f.label field
    out += f.text_field field
    out += f.error_message_on field
    out.html_safe
  end
  
  def auto_password_field f, field
    out = ''
    out += f.label field
    out += f.password_field field
    out += f.error_message_on field
    out.html_safe
  end
end
