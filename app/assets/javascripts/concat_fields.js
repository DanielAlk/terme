var ConcatFields = {};

ConcatFields.init = function() {
	$.fn.concatFields = ConcatFields.extension;
};

ConcatFields.extension = function() {
	this.each(ConcatFields.plugin);
};

ConcatFields.plugin = function() {
	var concat = this;
	var $concat = $(concat);
	var options = $concat.data();
	var $target = $concat.find('input[type=hidden]').first();
	var target_id = $target.attr('id');
	var structure = options.concat;
	var matches = structure.match(/\{\{\w+\}\}/g);
	var $elements = $();
	var input_ids = [];
	var match, match_index, text, input_id, elements_count;
	var init = function() {
		for (var key in matches) {
			match = matches[key];
			if ((match_index = structure.indexOf('{{')) > 0) {
				text = structure.substr(0, match_index);
				structure = structure.replace(text, '');
				$elements = $elements.add($('<span>', { text: text }));
			};
			input_id = target_id + '_' + match.replace(/[\{\}]/g, '');
			structure = structure.replace(match, '');
			input_ids.push(input_id);
			$elements = $elements.add($('<input>', { type: 'text', id: input_id }));
		};
		if (!!structure) $elements = $elements.add($('<span>', { text: structure }));
		$elements.each(function() {
			if (!elements_count) elements_count = $elements.length;
			$(this).css('width', String(100/elements_count) + '%');
		});
		$concat.append($elements);
		$elements.on('keyup', keyupHandler);
	};
	var keyupHandler = function(e) {
		var str = '';
		$elements.each(function() {
			var $element = $(this);
			str += $element.is('input') ? $element.val() : $element.text();
		});
		$target.val(str);
	};
	init();
};

$(ConcatFields.init);