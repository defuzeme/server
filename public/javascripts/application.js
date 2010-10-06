// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

window.addEvent('domready', function() {
  Alertbox.inject($('content'), 'top')
  window._alert = window.alert
  window.alert = function(message) { Alertbox.display(message) }
  $$('.flash').each(function(f) {
    f.removeClass('flash')
    Alertbox.display(f.get('text'), f.get('class'))
    f.dispose()
  })
})
