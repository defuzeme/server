// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Audio play control related
function play(playBtn) {
  pauseBtn = $(playBtn).next();
  pauseBtn.removeClass('hidden');
  $(playBtn).addClass('hidden');
  sendControl("play");
}

function pause(pauseBtn) {
  playBtn = $(pauseBtn).prev();
  playBtn.removeClass('hidden');
  $(pauseBtn).addClass('hidden');
  sendControl("pause");
}

function stop(btn) {
  sendControl("stop");
}

function next(btn) {
  sendControl("next");
}

function sendControl(action) {
  $.ajax("/radios/me/control?do=" + action, {'type': 'POST'});
}

// Domready
$(document).ready(function() {
  
  // Flash messages
  $('.flash').each(function(i, f) {
    close = $(f).append("<a class='close' href='#'>close</a>");
    window.setTimeout(function() {
      $(f).fadeOut(2000);
    }, 6000);
    close.click(function() {
      $(f).fadeOut(300);
      return false;
    })
  })

  // Queue sync
  var queue = $("ol.queue");
  if (queue.length)
  {
    var status = $("<div class=\"status sync\">Connecting to push server</div>");
    $("div#main").prepend(status);
    var timer;
    var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
    var ws = new Socket("ws://" + window.location.hostname + ":8080/push/" + queue.data("radio-id")+ "/web");
    ws.onmessage = function(evt) { 
      status.text("Syncing...");
      status.addClass("sync");
      if (timer) {
        clearTimeout(timer);
        timer = null
      }
      timer = setTimeout(function() {
        status.removeClass("sync");
        var d = new Date;
        status.text("Synced at " + d.toLocaleTimeString());
      }, 2000)
      queue.empty();
      queue.append(evt.data);
    };
    ws.onopen = function() {
      status.text("Connected to push server");
      status.removeClass("sync");
    };
    ws.onclose = function(e) {
      status.text("Can't connect to push server");
      status.removeClass("sync")
      status.addClass("error")    
    }
  };
  
  // Sortable queue + ajax
  queue.sortable({
    placeholder: "ui-placeholder",
    update: function(event, ui) {
      var order = queue.sortable("serialize");
      $.ajax({
        type: "PUT",
        url: "/radios/my/queue/reorder",
        data: order,
        success: function(msg){
        },
        complete: function(){  
        },
        error: function(jqXHR, textStatus, errorThrown)
        {
        }
      });
    }
	});
	queue.disableSelection();
})
