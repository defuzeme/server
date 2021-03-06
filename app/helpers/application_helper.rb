module ApplicationHelper
  def auto_field type, f, field, options = {}, &block
    out = ''
    out += f.label field
    out += f.send(type, field, options)
    out += content_tag(:div, capture(&block), :class => :details) if block_given?
    out += f.error_message_on field
    out.html_safe
  end

  def auto_text_field *args
    auto_field :text_field, *args
  end

  def auto_password_field *args
    auto_field :password_field, *args
  end

  def auto_check_box *args
    if args.last.is_a? Hash
      args.last.merge!(:class => 'checkbox')
    else
      args << {:class => 'checkbox'}
    end
    auto_field :check_box, *args
  end

  def auto_text_area f, field, options = {}, &block
    options.merge! :style => ''
    auto_field :text_area, f, field, options, &block
  end

  def auto_select f, field, options = {}
    if options.empty?
      options = f.object.class.send(field.to_s.pluralize).to_select
    end
    auto_field :select, f, field, options
  end
  
  def javascript *args
    content_for :head do
      javascript_include_tag *args
    end
  end
  
  def download_file file, title = nil, opts = {}
    render 'shared/download', :filename => file, :title => title, :options => opts
  end
end
