var Modals = {};

Modals.init = function() {
	$(document).on('shown.bs.modal', '.modal', function(e) {
		$(this).find('form input:not([type=hidden])').first().focus();
	});
	$(document).on('hidden.bs.modal', '.modal', function(e) {
		var $form = $(this).find('form');
		if ($form.length) $form.get(0).reset();
	});
};

Modals.contextForm = function(modalId, prefix) {
	var $modal = $('#' + modalId);
	var $form = $modal.find('form');
	var onShow = function(e) {
		var $btn = $(e.relatedTarget);
		var data = $btn.data();
		for (var name in data) {
			if (name == 'toggle' || name == 'target') continue;
			var $input = $form.find('input[name="'+prefix+'\['+name+'\]"]');
			if (!$input.length) continue;
			$input.val(data[name]);
		};
	};
	$modal.on('show.bs.modal', onShow);
	$form.validate();
};

$(Modals.init);