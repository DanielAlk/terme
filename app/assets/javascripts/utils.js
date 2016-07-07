var Utils = {};

Utils.collapseCaret = function() {
	var findFa = function(element) {
		return $('[data-toggle="collapse"][href="#'+$(element).attr('id')+'"] .fa');
	};
	$('.collapse').on('show.bs.collapse', function(e) {
		e.stopPropagation();
		findFa(this).addClass('fa-flip-vertical');
	});
	$('.collapse').on('hide.bs.collapse', function(e) {
		e.stopPropagation();
		findFa(this).removeClass('fa-flip-vertical');
	});
};