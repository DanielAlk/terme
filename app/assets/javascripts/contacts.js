var Contacts = {};

Contacts.index = function() {
	var updateToggle = function(e, contact) {
	  var is_read = contact.read;
	  var $toggler = $('#contact_' + contact.id + ' .contact-read-toggler');
	  $toggler.data('hash', { contact: { read: !is_read }});
	  $toggler.find('.fa').removeClass('fa-bookmark fa-bookmark-o').addClass(is_read ? 'fa-bookmark' : 'fa-bookmark-o');
	  $toggler.tooltip('destroy');
	  $toggler.attr('title', is_read ? 'Marcar como no leído' : 'Marcar como leído');
	  $toggler.tooltip();
	  $('#contact_' + contact.id).removeClass('info success').addClass(is_read ? 'info' : 'success');
	};
	var updatedMany = function(e, response) {
	  for (var key in response) updateToggle(e, response[key]);
	  Alerts.success('Se cambiaron con exito los contactos seleccionados');
	};
	var submitFilterable = function() {
	  $(this).closest('form').submit();
	};
	$('[data-util=updateMany]').on('updated.util.updateMany', updatedMany);
	$('.contact-read-toggler').on('updated.util.update', updateToggle);
	$('#filterable-contacts select').change(submitFilterable);
	Contacts.clipboard();
	Utils.checkboxes();
	Utils.selectpicker();
	Utils.deleteManyForm();
	Utils.updateMany();
};

Contacts.clipboard = function() {
	var clipboard = new Clipboard('.clipboard-trigger');
	var $trigger = $('.clipboard-trigger');
	var $checkboxes = $('.checkbox-target');
	$checkboxes.change(function(e) {
		$trigger.attr('disabled', !$checkboxes.filter(':checked').length);
	});
	clipboard.on('success', function(e) {
		Alerts.success('Se copiaron los emails al portapapeles.');
	});
	clipboard.on('error', function(e) {
		Alerts.danger('No se pudo copiar... tu navegador no es compatible.');
	});
	$trigger.click(function(e) {
		e.preventDefault();
		var text = '';
		$('.clipboard-field').each(function() {
			text += $(this).text() + ', ';
		});
		$trigger.attr('data-clipboard-text', text.substr(0, text.length - 2));
	});
};