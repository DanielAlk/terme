var Pages = {};

Pages.home = function() {
	$('section .owl-carousel').owlCarousel({
		loop:false,
		items:1,
		slideBy:1,
		margin:0,
		nav: true,
		dots: false,
		responsive:{
			0:{items:1},
			650:{items:2},
			800:{items:3},
			1025:{items:4},
			1251:{items:5}
		}
	});
	$('.slider-bottom .owl-carousel').owlCarousel({
		loop:true,
		items:1,
		margin:0,
		nav:true,
		dots:true,
		responsive:{
			0:{ items:1}
		}
	});
};

Pages.products = function() {
	$('.products-page-filters select').change(function(e) {
	  $(this).closest('form').submit();
	});
};

Pages.product = function(product) {
	AriaProductInit();
	$('#star_' + product.score).click();
	$('.rating input').click(function(e) {
	  e.preventDefault();
	});
	$('#galeria-thumbs.owl-carousel').owlCarousel({
	  loop:false,
	  items:3,
	  margin:0,
	  nav:true,
	  dots:false,
	  responsive:{
	      0:{ items:3}
	  }
	});	
	$('section.relacionados .owl-carousel').owlCarousel({
	  loop:false,
	  items:1,
	  slideBy:1,
	  margin:0,
	  nav: true,
	  dots: false,
	  responsive:{
	    0:{items:1},
	    650:{items:2},
	    800:{items:3},
	    1025:{items:4},
	    1251:{items:5}
	  }
	});
};

Pages.cart = function() {
	(function() {
		var el = $('.producto01 .qty');
		var change = function(amt) { el.val(parseInt(el.val(),10) + amt); };
  	$('.mas').click(function() { change(1); });
  	$('.menos').click(function() {change(-1); });
  })();

  (function() { 
  	var el = $('.producto02 .qty');
  	var change = function(amt) { el.val( parseInt( el.val(), 10 ) + amt ); };
  	$('.mas2').click(function() { change(1); });
  	$('.menos2').click(function() { change(-1); });
  })();

  $('section.relacionados .owl-carousel').owlCarousel({
  	loop:false,
  	items:1,
  	slideBy:1,
  	margin:0,
  	nav: true,
  	dots: false,
  	responsive:{
  		0:{items:1},
  		650:{items:2},
  		800:{items:3},
  		1025:{items:4},
  		1251:{items:5}
  	}
  });
};

Pages.carousel = function() {
	$('.slider.owl-carousel').owlCarousel({
	  loop:true,
	  items:1,
	  margin:0,
	  nav:true,
	  dots:true,
	  autoPlay: 7000,
	  stopOnHover: true,
	  responsive:{
	      0:{ items:1}
	  }
	});
};