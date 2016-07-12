var FilePicker = {};

FilePicker.load = function() {
	$.fn.filePicker = FilePicker.extension;
};

FilePicker.extension = function(data_appends) {
	FilePicker.data_appends = data_appends;
	this.each(FilePicker.plugin);
};

FilePicker.plugin = function() {
	var picker = this;
	var images_container_selector = $(this).data('images');
	var $images_container = $(images_container_selector);
	var $template = $($(this).data('template'));
	var items = new FilePicker.Items;
	var is_loading = false;
	items.allDoneCallback = function() {
		is_loading = false;
		$images_container.children().removeClass('loading');
		$images_container.sortable('enable');
	};
	var now_is_loading = function(keep_sortable_enabled) {
		is_loading = true;
		if (!keep_sortable_enabled) $images_container.sortable('disable');
	};
	var deleteFile = function(e) {
		if (is_loading) return false;
		now_is_loading();
		e.preventDefault();
		var $item = $(this).closest('.file-picker-image').addClass('loading');
		var id = $(this).data('id');
		items.delete(id);
		$item.remove();
	};
	var user_selection = function(e) {
		if (is_loading) return false;
		now_is_loading();
		var files = this.files;
		for (var key in files) (function() {
			var item = files[key];
			if (typeof item != 'object') return false;
			var $item = $template.clone();
			var $input = $item.find('input');
			var $image = $item.find('.image');
			var $delete = $item.find('.delete');
			var item_id = items.count();
			var input_old_id = $input.attr('id');
			$item.attr('id', 'file_picker_' + item_id);
			$delete.data('id', item_id);
			$images_container.append($item);
			$item.addClass('loading');
			FilePicker.readFileAndShow(item, $image);
			items.create(item, function(response) {
				var input_new_id = input_old_id + response.id;
				var input_new_name = $input.attr('name').replace('[]', '[' + response.id + ']');
				$input.attr({ id: input_new_id, name: input_new_name });
				$item.removeClass('loading');
			});
		})();
	};
	var loadPicker = function(e) {
		$images_container.children().each(function(e) {
			var image = $(this).data();
			items.append(new FilePicker.File(image.id, image.position, image.item));
		});
	};
	var updatePositions = function(e, ui) {
		now_is_loading(true);
		$(ui.item).addClass('loading');
		var sortable = $images_container.sortable('toArray');
		var data = new FormData;
		sortable.forEach(function(s, i) {
			var position = i+1;
			var index = Number(s.substr(s.lastIndexOf('_')+1));
			var item = items.find(index);
			if (position != item.position) {
				item.position = position;
			};
		});
		items.each(function(item) {
			if (!!item) {
				data.append('image[ids][]', item.id);
				data.append('image[positions][]', item.position);
			};
		});
		items.update(data);
	};
	$images_container.sortable({ update: updatePositions, placeholder: 'file-picker-image' });
	$(picker).change(user_selection).ready(loadPicker);
	$(document).on('click', images_container_selector + ' a.delete', deleteFile)
  $images_container.disableSelection();
};

FilePicker.FormData = function() {
	var obj = new FormData;
	var data = FilePicker.data_appends;
	for (var key in data) {
		obj.append('image['+key+']', data[key]);
	};
	return obj;
};

FilePicker.File = function(id, position, item) {
	var obj = this;
	obj.id = id;
	obj.position = position;
	obj.item = item;
	obj.save = function(callback) {
		callback = typeof callback != 'function' ? function(){} : callback;
		var data = new FilePicker.FormData;
		data.append('image[item]', obj.item);
		FilePicker.upload(data, function(response, status, location) {
			obj.id = response.id;
			obj.position = response.position;
			callback(response, status, location);
		});
		return obj;
	};
	obj.update = function(position, callback) {
		var data = new FormData;
		data.append('image[position]', position);
		FilePicker.update(obj.id, data, callback);
		return obj;
	};
	obj.delete = function(callback) {
		FilePicker.delete(obj.id, callback)
		return null;
	};
	return obj;
};

FilePicker.Items = function() {
	var obj = this;
	obj.queue = [];
	obj.list = [];
	obj.allDone = function() {
		if (typeof obj.allDoneCallback == 'function') obj.allDoneCallback(obj);
	};
	obj.append = function(item) {
		return obj.list.push(item);
	};
	obj.find = function(key) {
		return obj.list[key];
	};
	obj.delete = function(key) {
		return obj.list[key] = obj.list[key].delete(obj.allDone);
	};
	obj.count = function() {
		return obj.list.length;
	};
	obj.each = function(callback) {
		return obj.list.forEach(callback);
	};
	obj.update = function(data) {
		return FilePicker.update_all(data, obj.allDone);
	};
	obj.create = function(item, callback) {
		callback = typeof callback != 'function' ? function(){} : callback;
		var new_item = new FilePicker.File(undefined, undefined, item);
		obj.append(new_item);
		obj.queue.push(new_item);
		new_item.save(function(response, status, location) {
			obj.queue.splice(obj.queue.indexOf(new_item), 1);
			callback(response, status, location);
			if (!obj.queue.length) obj.allDone();
		});
		return new_item;
	};
	return obj;
};

FilePicker.readFileAndShow = function(file, $image) {
	var reader = new FileReader;
	reader.onload = function(e) {
		var imageAsURL = e.target.result;
		$image.css({ 'background-image': 'url(' + imageAsURL + ')' });
		reader = null;
	};
	reader.readAsDataURL(file);
};

FilePicker.upload = function(data, callback) {
	callback = typeof callback != 'function' ? function(){} : callback;
	$.ajax({ url: '/images/', data: data, type: 'POST', contentType: false, processData: false, dataType: 'json' })
	.done(callback)
	.fail(function() { console.log(arguments); });
};

FilePicker.update = function(id, data, callback) {
	callback = typeof callback != 'function' ? function(){} : callback;
	$.ajax({ url: '/images/'+id, data: data, type: 'PUT', contentType: false, processData: false, dataType: 'json' })
	.done(callback)
	.fail(function() { console.log(arguments); });
};

FilePicker.update_all = function(data, callback) {
	callback = typeof callback != 'function' ? function(){} : callback;
	$.ajax({ url: '/images/', data: data, type: 'PUT', contentType: false, processData: false, dataType: 'json' })
	.done(callback)
	.fail(function() { console.log(arguments); });
};

FilePicker.delete = function(id, callback) {
	callback = typeof callback != 'function' ? function(){} : callback;
	$.ajax({ url: '/images/'+id, type: 'DELETE', dataType: 'json' })
	.done(callback)
	.fail(function() { console.log(arguments); });
};

$(FilePicker.load);