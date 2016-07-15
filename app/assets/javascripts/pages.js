var Pages = {};

Pages.product = function(stock) {
	AriaProductInit();
	Pages.quantityPicker(stock);
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

Pages.quantityPicker = function(stock) {
	var $el = $('.qty');
	var change = function(amt) {
    var val = parseInt($el.val(),10) + amt;
    val = val > 0 ? val : $el.val();
    val = val <= stock ? val : stock;
    val = !!Number(val) ? val : 1;
    $el.val(val);
  };
  var keydownHandler = function(e) {
    switch(e.which) {
      case 38: change(1); break;
      case 40: change(-1); break;
      case 37: case 39: case 16: case 17: case 18: case 8: case 13: case 46: break;
      default: if (!Number(String.fromCharCode(e.which)) && Number(String.fromCharCode(e.which)) != 0) e.preventDefault();
    };
  };
  var focusoutHandler = function(e) {
    if (!Number($el.val())) $el.val(1);
    if (Number($el.val()) > stock) $el.val(stock);
  };
  $('#quantity .mas').click(function() { change(1); });
  $('#quantity .menos').click(function() { change( -1 ); });
  $('#quantity').disableSelection();
  $el.keydown(keydownHandler).focusout(focusoutHandler);
};