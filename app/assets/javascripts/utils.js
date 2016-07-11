var Utils = {};

Utils.collapseCaret = function() {
	var findFa = function(element) {
		return $('[data-toggle="collapse"][href="#'+$(element).attr('id')+'"] .fa');
	};
	$(document).on('show.bs.collapse', '.collapse', function(e) {
		e.stopPropagation();
		findFa(this).addClass('fa-flip-vertical');
	});
	$(document).on('hide.bs.collapse', '.collapse', function(e) {
		e.stopPropagation();
		findFa(this).removeClass('fa-flip-vertical');
	});
};

Utils.delete = function() {
	var triggerClick = function(e) {
		e.preventDefault();
		var $trigger = $(this);
		var options = $trigger.data();
		var $remove = !!options.remove && $trigger.closest(options.remove);
		var $parent = !!options.remove && $remove.parent();
		$.ajax({ url: $trigger.attr('href'), method: 'delete', dataType: 'json' })
		.done(function(response) {
			if (!!options.remove) $remove.fadeOut(function() {
				$remove.remove();
				$(document).trigger('removed.util.delete', [ $parent.length ? $parent.get(0) : null ]);
			});
		});
	};
	$(document).on('click', '[data-util=delete]', triggerClick);
};

Utils.update = function() {
	var triggerClick = function(e) {
		e.preventDefault();
		var $trigger = $(this);
		var options = $trigger.data();
		$.ajax({ url: $trigger.attr('href'), method: 'put', dataType: 'json', data: options.hash })
		.done(function(response) {
			$trigger.trigger('updated.util.update', [ response ]);
		});
	};
	$(document).on('click', '[data-util=update]', triggerClick);
};

Utils.templates = function() {
	var inputsFromData = function(data) {
		if (!data) return null;
		var $obj = $();
		for (var key in data) {
			var val = data[key];
			var $hidden = $('<input>', { type: 'hidden', name: key, value: val });
			$obj = $obj.add($hidden);
		};
		return $obj;
	};
	var triggerClick = function(e) {
		e.preventDefault();
		var $trigger = $(this);
		var options = $trigger.data();
		var $clone = $(options.template).clone().removeAttr('id');
		var $target = $(options.target);
		if (!!options.inputs) {
			var $inputs = inputsFromData(options.inputs);
			var $form = $clone.find('form');
			$form.append($inputs);
		};
		$clone.appendTo($target);
		$trigger.trigger('inserted.util.templates', [$trigger.get(0), $clone.get(0), $target.get(0)]);
	};
	$(document).on('click', '[data-util=template]', triggerClick);
};

Utils.handleAjaxErrors = function() {
	$(document).ajaxError(function(event, xhr, settings, thrownError) {
		Alerts.danger('Ocurrió un error de conexión debido a: <small>' + thrownError.toString() + '</small>');
		console.log(arguments);
	});
};

Utils.class = function() {
	$(document).on('click', '[data-util=class]', function(e) {
		!!this.href && e.preventDefault();
		var $this = $(this);
		var options = $this.data();
		var $target = !!options.target ? $(options.target) : $($this.attr('href'));
		if (!!options.toggle) $target.toggleClass(options.toggle);
		else if (!!options.remove) $target.removeClass(options.remove);
		else if (!!options.add) $target.addClass(options.add);
	});
};

Utils.onload = function() {
	Utils.handleAjaxErrors();
	Utils.collapseCaret();
	Utils.templates();
	Utils.class();
	Utils.delete();
	Utils.update();
};

$(Utils.onload);