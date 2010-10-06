// AlertBox

var Alertbox = new Element('div', { id: 'alert', styles: { 'top': 5, 'z-index': -1 }})
$extend(Alertbox, {
  display: function(message, classes) {
    message = '' + message
    if (this.timeout) this.timeout = $clear(this.timeout)
    this.addClass(classes)
    this.set('text', this.get('text') + message).reposition()
    this.myFx = new Fx.Tween(this, {property: 'top'});
    this.myFx.start(-35).chain(function() {
      this.setStyle('z-index', 1)
      this.myFx.start(-10)
    }.bind(this))
    this.addEvent('click', function() {
      this.hide()
    }.bind(this))
    this.timeout = this.hide.delay(2000 + message.length * 30, this)
  },
  wait: function() {
    this.display(_('wait'), -1)
  },
  reposition: function() {
    this.setStyles({
      'top': 5,
      'z-index': -1
    })
    return this
  },
	xpos: function() {
		return Math.round((document.documentElement.scrollLeft || document.body.scrollLeft) +
            (window.getWidth() - this.getWidth()) / 2);
	},
	ypos: function() {
		return Math.round((document.documentElement.scrollTop || document.body.scrollTop) +
            (window.getHeight() - this.getHeight()) / 2)
	},
  hide_unless_delayed: function() {
    if (!this.timeout && this.getStyle('opacity') > 0) this.hide()
  },
  hide: function() {
    this.myFx.start(-35).chain(function() {
      this.setStyle('z-index', -1)
      this.myFx.start(5).chain(function() {
        this.set('text', '')
      })
    }.bind(this))
  }
})

