var Alerts = {};

Alerts.notice = function() {
	var timer;
	var $alert = $('#alertNotice');
	var fadeOutAndRemove = function($alert) {
		if (!$alert.length) return;
		$alert.fadeOut(function() {
			if (!$alert.length) return;
			$alert.remove();
		});
	};
	$alert.find('button.close').click(function(e) {
		e.preventDefault();
		fadeOutAndRemove($alert);
		clearTimeout(timer);
	});
	$alert.fadeIn(function() {
		timer = setTimeout(function() {
			fadeOutAndRemove($('#alertNotice'));
		}, 6000);
	});
};

Alerts.danger = function(text) {
	Alerts.generate(text, 'alert-danger');
};

Alerts.success = function(text) {
	Alerts.generate(text, 'alert-success');
};

Alerts.generate = function(text, alertClass) {
	var alert = '<div class="alert '+ alertClass +' alert-dismissible" role="alert" id="alertNotice" style="display:none;">';
	alert+= '<button type="button" class="close" aria-label="Close"><span aria-hidden="true">&times;</span></button>';
	alert+=	text;
	alert+= '</div>';
	$('#alertNotice').remove();
	$('body').append(alert);
	Alerts.notice();
};