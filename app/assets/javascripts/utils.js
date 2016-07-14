var Utils = {};

Utils.radios = function() {
	$('.radio-inline>input[type=radio]').each(function() {
		if (this.checked) $(this).parent().addClass('active');
	});
};

Utils.radios.init = function() {
	$(document).on('change', '.radio-inline>input[type=radio]', function(e) {
		var target = this;
		$('input[type=radio]').filter(function() {
			return target.name == this.name;
		}).parent().removeClass('active');
		$(this).parent().addClass('active');
	});
};

Utils.checkboxes = function() {
	$('.checkbox-inline>input[type=checkbox]').each(function() {
		if (this.checked) $(this).parent().addClass('active');
	});
	$('.checkbox-inline>input[type=checkbox][name=select_all]').each(function() {
		var element = this;
		var selector = $(element).data('target');
		var $targets = $('input[type=checkbox]'+selector);
		if ($targets.filter(':checked').length == $targets.length) $(element).prop('checked', true).parent().addClass('active');
		$targets.data('master', element);
	});
};

Utils.checkboxes.init = function() {
	$(document).on('change', '.checkbox-inline>input[type=checkbox]', function(e) {
		$(this).parent().toggleClass('active');
		var master = $(this).data('master');
		if (master) {
			if (master.checked && !this.checked) $(master).prop('checked', false).parent().removeClass('active');
			else if (!master.checked) {
				var selector = $(master).data('target');
				var $targets = $('input[type=checkbox]'+selector);
				if ($targets.filter(':checked').length == $targets.length) $(master).prop('checked', true).parent().addClass('active');
			};
		};
	});
	$(document).on('change', '.checkbox-inline>input[type=checkbox][name=select_all]', function(e) {
		var element = this;
		var selector = $(element).data('target');
		var $targets = $('input[type=checkbox]'+selector);
		$targets.filter(function() {
			return $(element).is(':checked') != $(this).is(':checked');
		}).click();
	});
};

Utils.selectpicker = function() {
	$('.selectpicker').selectpicker({size:10, selectOnTab:true});
	$('.selectpicker-search').selectpicker({size:10, selectOnTab:true, liveSearch: true, liveSearchNormalize: true, liveSearchPlaceholder: 'Buscar'});
	$('.selectpicker-submit').on('change.bs.select', function(e) {
		$(this).closest('form').submit();
	});
};

Utils.autonumeric = function() {
	$('input.autonumeric').autoNumeric('init', { aSep: '.', aDec: ',', aPad: false });
	$('input.autonumeric-price').autoNumeric('init', { aSep: '.', aDec: ',', aPad: 2 });
};

Utils.addOptionToSelect = function() {
	$('form').each(function() {
		if (!$(this).find('.add_option_to_select').length) return;
		var form = this;
		var $form = $(form);
		$form.submit(function(e) {
			var $input = $(this).find('.add_option_to_select:focus');
			if (!$input.length) return;
			var $select = $($input.data('select'));
			var value = $input.val();
			var $repeated = $select.find('option').filter(function() {
				if (value.toLowerCase() == $(this).text().toLowerCase()) return this;
			});
			if ($repeated.length) Alerts.danger('Esa opción ya existe');
			else if (value.length < 3) Alerts.danger('La opción debe tener al menos 3 caracteres');
			else {
				$select.append($('<option>', { text: value, selected: true }))
				.selectpicker('refresh');
				$input.val(null);
				Alerts.success('Se agregó ' + value);
			};
			return false;
		});
	});
};

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

Utils.deleteManyForm = function() {
	var init = function() {
		var $trigger = $(this);
		var options = $trigger.data();
		var selector = options.ids;
		var $checkboxes = $(selector);
		$checkboxes.change(function(e) {
			$trigger.attr('disabled', !$checkboxes.filter(':checked').length);
		});
	};
	var clickHandler = function(e) {
		e.preventDefault();
		var $trigger = $(this);
		var options = $trigger.data();
		var $form = $(options.target);
		var selector = options.ids;
		var $checkboxes = $(selector);
		$checkboxes.filter(':checked').each(function() {
			$('<input>', { type: 'hidden', name: 'ids[]', value: $(this).val() })
			.appendTo($form);
		});
		$form.submit();
	};
	$('[data-util=deleteManyForm]').each(init);
	$('[data-util=deleteManyForm]').click(clickHandler);
};

Utils.updateMany = function() {
	var init = function() {
		var $trigger = $(this);
		var options = $trigger.data();
		var selector = options.ids;
		var $checkboxes = $(selector);
		$checkboxes.change(function(e) {
			$trigger.attr('disabled', !$checkboxes.filter(':checked').length);
		});
	};
	var clickHandler = function(e) {
		e.preventDefault();
		var $trigger = $(this);
		if ($trigger.hasClass('updating')) return;
		var options = $trigger.data();
		var hash = options.hash;
		var selector = options.ids;
		var $checkboxes = $(selector);
		var ids = [];
		$checkboxes.filter(':checked').each(function() {
			ids.push($(this).val());
		});
		hash.ids = ids;
		$trigger.addClass('updating');
		$.ajax({ url: $trigger.attr('href'), method: 'put', dataType: 'json', data: hash })
		.done(function(response) {
			$trigger.trigger('updated.util.updateMany', [ response ]);
		})
		.always(function() {
			$trigger.removeClass('updating');
		});
	};
	$('[data-util=updateMany]').each(init);
	$('[data-util=updateMany]').click(clickHandler);
};

Utils.deleteMany = function() {
	var init = function() {
		var $trigger = $(this);
		var options = $trigger.data();
		var selector = options.ids;
		var $checkboxes = $(selector);
		$checkboxes.change(function(e) {
			$trigger.attr('disabled', !$checkboxes.filter(':checked').length);
		});
	};
	var clickHandler = function(e) {
		e.preventDefault();
		var $trigger = $(this);
		if ($trigger.hasClass('updating')) return;
		var options = $trigger.data();
		if (!options.confirmText || !window.confirm(options.confirmText)) return;
		var selector = options.ids;
		var $checkboxes = $(selector);
		var ids = [];
		var $remove = $();
		$checkboxes.filter(':checked').each(function() {
			var $checkbox = $(this);
			ids.push($checkbox.val());
			if (!!options.remove) $remove = $remove.add($checkbox.closest(options.remove));
		});
		$trigger.addClass('updating');
		$.ajax({ url: $trigger.attr('href'), method: 'delete', dataType: 'json', data: { ids: ids } })
		.done(function(response) {
			if (!!options.remove) $remove.fadeOut(function() {
				$remove.remove();
				$trigger.trigger('removed.util.deleteMany');
			});
		})
		.always(function() {
			$trigger.removeClass('updating').attr('disabled', true);
			$('[data-util=deleteMany][data-ids="'+options.ids+'"]').attr('disabled', true);
			$('[data-util=updateMany][data-ids="'+options.ids+'"]').attr('disabled', true);
		});
	};
	$('[data-util=deleteMany]').each(init);
	$('[data-util=deleteMany]').click(clickHandler);
};

Utils.delete = function() {
	var triggerClick = function(e) {
		e.preventDefault();
		var $trigger = $(this);
		var options = $trigger.data();
		var $remove = !!options.remove && $trigger.closest(options.remove);
		var $parent = !!options.remove && $remove.parent();
		var $event = !!options.event && $(options.event);
		$.ajax({ url: $trigger.attr('href'), method: 'delete', dataType: 'json' })
		.done(function(response) {
			if (!!options.remove) $remove.fadeOut(function() {
				$remove.remove();
				if ($event.length) $event.trigger('removed.util.delete', [ $parent.length ? $parent.get(0) : null ]);
			});
		});
	};
	$(document).on('click', '[data-util=delete]', triggerClick);
};

Utils.update = function() {
	var triggerClick = function(e) {
		e.preventDefault();
		var $trigger = $(this);
		if ($trigger.hasClass('updating')) return;
		var options = $trigger.data();
		$trigger.addClass('updating');
		$.ajax({ url: $trigger.attr('href'), method: 'put', dataType: 'json', data: options.hash })
		.done(function(response) {
			$trigger.trigger('updated.util.update', [ response ]);
		})
		.always(function() {
			$trigger.removeClass('updating');
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

Utils.disableAfterClick = function() {
	var clickHandler = function(e) {
		$(this).addClass('disabled').attr('disabled', true);
		$('<div>', { id: 'disable-after-click-layer' })
		.css({ position: 'absolute', top: 0, left: 0, zIndex: 99999999, width: '100%', height: '100%' })
		.prependTo('body');
	};
	var clickHandlerDisabled = function(e) {
		return false;
	};
	$(document).on('click', '.disable-after-click:not(.disabled)', clickHandler);
	$(document).on('click', '.disable-after-click.disabled, disable-after-click-layer', clickHandlerDisabled);
};

Utils.submitTriggers = function() {
	$(document).on('click', '[data-submit]', function(e) {
		e.preventDefault();
		$($(this).data('submit')).submit();
	});
};

Utils.handleAjaxErrors = function() {
	$(document).ajaxError(function(event, xhr, settings, thrownError) {
		var string = '';
		if (!!xhr && typeof xhr.responseJSON == 'object') {
			for (var key in xhr.responseJSON) {
				string += '<b>' + key + '<b>: <small>' + xhr.responseJSON[key].join(', ') + '</small><br>';
			}
		} else string = 'Ocurrió un error: <small>' + thrownError.toString() + '</small>';
		Alerts.danger(string);
		console.log(arguments);
	});
};

Utils.onload = function() {
	Utils.handleAjaxErrors();
	Utils.collapseCaret();
	Utils.templates();
	Utils.radios.init();
	Utils.checkboxes.init();
	Utils.disableAfterClick();
	Utils.submitTriggers();
	Utils.class();
	Utils.delete();
	Utils.update();
};

$(Utils.onload);