var User = {};

User.addresses = function() {
	$('[data-util=update]').on('updated.util.update', function(e, response) {
		var $panel = $(this).closest('.panel');
		var $group = $('#group-root');
		$group.find('.is-first').addClass('hidden');
		$group.find('[data-util=update]').removeClass('hidden');
		$panel.prependTo($group).find('[data-util=update]').addClass('hidden');
		$panel.find('.is-first').removeClass('hidden');
		Alerts.success('Se marcó la dirección como principal');
	});
	$('#group-root').on('removed.util.delete', function() {
		Alerts.success('Se eliminó la dirección');
	});
};