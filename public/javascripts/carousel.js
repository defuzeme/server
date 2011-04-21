jQuery(document).ready(function() {

	var index = 0;
	var elements = jQuery('#imageslist').size();
	var timer = setInterval(rotate, 3500);

	jQuery('#carousel-images').mouseover(function() {
		clearInterval(timer);
	    });

	jQuery('#carousel-images').mouseout(function() {
		timer = setInterval(rotate, 3500);
	    });

	jQuery('#slide-left').click(function() {
		clearInterval(timer);
		rotate_right();
		timer = setInterval(rotate, 3500);
	    });
	jQuery('#slide-right').click(function() {
		clearInterval(timer);
		rotate_left();
		timer = setInterval(rotate, 3500);
	    });

	function rotate_left() {
	    if (index <= elements) {
		index += 1;
		jQuery('#imageslist').animate({
			left: "-=515px",
			    }, 1000, function() {return true});
	    } else {
		return false;
	    }
	}
	
	function rotate_right() {
	    if (index > 0) {
		index -= 1;
		jQuery('#imageslist').animate({
			left: "+=515px",
			    }, 1000, function() {return true});
	    } else {
		return false;
	    }
	}

	function rotate_init() {
	    index = 0;
	    jQuery('#imageslist').animate({
		    left: "0",
			}, 1000, function() {return true});
	}

	function rotate() {
	    if (rotate_left() == false) {
		rotate_init();
	    }
	}

    });