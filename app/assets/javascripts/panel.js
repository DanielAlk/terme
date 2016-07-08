var Panel = {};

Panel.categories = function() {
	var insertedHandler = function(e, trigger, panel, target) {
	  var $group = $(target).parent('.collapse');
	  var $panel = $(panel);
	  var $editable = $panel.find('.editable');
	  var $parentPanel = $panel.parents('.panel').first();
	  if ($group.length) {
	    $group.removeClass('hidden');
	    $group.closest('.panel').find('[data-toggle=collapse]').first()
	    .removeClass('hidden')
	    .attr('href', '#' + $group.attr('id'))
	    .click(function() {
	      $group.collapse('toggle');
	    });
	    $group.collapse('show');
	  };
	  if ($parentPanel.length) {
	  	var parentDepth = Number($parentPanel.attr('class').match(/d\d+/)[0].substr(1));
	  	$panel.removeClass('d0').addClass('d' + String(parentDepth+1));
	  };
	  $editable.editable(editableCallback).find('input:not([type=hidden])').focus();
	};

	var editableCallback = function(form, response) {
	  var $form = $(form);
	  var $panel = $form.closest('.panel');
	  var url = 'categories/' + response.slug;
	  var $method = $form.find('input[type=hidden][name=_method]');
	  if ($method.length) $method.val('patch');
	  else $form.append($('<input>', { type: 'hidden', name: '_method', value: 'patch' }));
	  $form.attr('action', url)
	  .removeAttr('class').addClass('edit_category')
	  .attr('id', 'edit_category_' + response.id)
	  .find('#new_category_title').attr('id', 'category_' + response.id + '_title');
	  $panel.find('.link-danger, .link-success').removeClass('hidden');
	  $panel.find('#group-').attr('id', 'group-' + response.id);
	  $panel.find('[data-util=delete]').attr('href', url);
	  $templateTrigger = $panel.find('.link-success');
	  $templateTrigger.attr('data-target', '#group-' + response.id + '>.panel-group');
	  $templateTrigger.attr('data-inputs', JSON.stringify({
	    'category[ancestry_id]' : response.id
	  }));
	  Alerts.success('La categoría se guardó con exito');
	};

	var handleEmptyNewCategories = function(e) {
		var $input = $(this);
		if ($input.attr('id') == 'new_category_title') $input.closest('.panel').fadeOut(function() {
			var group = this.parentElement;
			$(this).remove();
			afterDeleted(e, group);
		});
	};

	var afterDeleted = function(e, group) {
		var $group = $(group);
		if ($group.children().length) return;
		var $collapse = $group.closest('.collapse');
		$('[data-toggle=collapse][href="#'+$collapse.attr('id')+'"]')
		.addClass('hidden')
		.find('.fa');
		$collapse.addClass('hidden');
	};

	$('.editable').editable(editableCallback);
	$(document).on('focusout', '[name=category\\[title\\]]', handleEmptyNewCategories);
	$(document).on('inserted.util.templates', '[data-util=template]', insertedHandler);
	$(document).on('removed.util.delete', afterDeleted);
};