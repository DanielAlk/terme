var Editable = {};

Editable.init = function() {
	$.fn.editable = Editable.extension;
};

Editable.extension = function(callback) {
	this.each(function() {
		Editable.plugin.call(this, callback)
	});
	return this;
};

Editable.plugin = function(callback) {
	var $editable = $(this);
	var $text = $editable.children('span');
	var $form = $editable.find('form');
	var $input = $form.find('input:not([type=hidden])').first();
	var param = $input.attr('name').replace(/\w+\[(\w+)\]/, '$1');
	var textClick = function(e) {
		$editable.addClass('editing');
		$input.focus();
	};
	var handleSubmit = function() {
		$.ajax({ url: $form.attr('action'), method: $form.attr('method'), data: $form.serialize(), dataType: 'json' })
		.done(function(response) {
			$text.text(response[param]);
			$text.parent().removeClass('editing');
			callback && callback.apply(this, $.merge([$form.get(0)], arguments));
		});
	};
	$text.click(textClick);
	$form.validate({ submitHandler: handleSubmit })
};

$(Editable.init);