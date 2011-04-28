module FancyHelper
  def fancy_monitor image = "monitor_default.jpg", options = {}
    klass = ['fancy-monitor', options[:class]].compact.join(' ')
    content_tag 'div', :class => klass do
      image_tag(image) + 
      content_tag('div', '', :class => 'overlay')
    end
  end

  def fancy_tablet image = "tablet_default.jpg", options = {}
    klass = ['fancy-tablet', options[:class]].compact.join(' ')
    content_tag 'div', :class => klass do
      image_tag(image) + 
      content_tag('div', '', :class => 'overlay')
    end
  end

end
