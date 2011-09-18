// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// TODO: rewrite in jQuery

/*
window.addEvent('domready', function() {
  $$('.flash').each(function(f) {
    close = new Element('a', {'class': 'close', text: 'close', href: ''})
    close.inject(f)
    close.addEvent('click', function(e) {
      e.stop()
      f.dispose()
      return false
    })
  })
})*/

$(document).ready(function() {
  var queue = $("ol.queue");
  if (queue.length)
  {
    var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
    var ws = new Socket("ws://" + window.location.hostname + ":8080/");
    ws.onmessage = function(evt) { 
      queue.empty();
      queue.append(evt.data);
    };
    ws.onclose = function() { };
    ws.onopen = function() {
      alert("connected...");
    };
  };
})
