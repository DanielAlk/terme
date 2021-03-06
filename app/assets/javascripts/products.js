var Products = {};

Products.index = function() {
  var status_translated = {draft: 'Borrador', active: 'Activa', paused: 'Pausada', trash: 'Borrada'};
  var label_class = {draft: 'info', active: 'success', paused: 'danger', trash: 'danger'};
  var updateToggle = function(e, product) {
  	var is_active = product.status == 'active';
  	var $toggler = $('#product_' + product.id + ' .product-active-toggler');
  	$toggler.data('hash', { product: { status: is_active ? 'paused' : 'active' }});
  	$toggler.find('.fa').removeClass('fa-play fa-pause').addClass(is_active ? 'fa-pause' : 'fa-play');
  	$toggler.tooltip('destroy');
  	$toggler.attr('title', is_active ? 'Pausar' : 'Activar');
  	$toggler.tooltip();
  	$('#product_status_' + product.id)
  	.text(status_translated[product.status])
  	.removeClass('label-info label-success label-danger')
  	.addClass('label-' + label_class[product.status]);
  };
  var updateSpecialToggle = function(e, product) {
  	var is_new = product.special == 'is_new';
  	var is_offer = product.special == 'is_offer';
  	var $display = $('#product_' + product.id);
  	var $togglerNew = $display.find('.product-new-toggler');
  	var $togglerOffer = $display.find('.product-offer-toggler');
  	$togglerNew.data('hash', { product: { special: is_new ? 'is_regular' : 'is_new' }});
  	$togglerNew.find('.fa').removeClass('fa-flag fa-flag-o').addClass(is_new ? 'fa-flag' : 'fa-flag-o');
  	$togglerNew.tooltip('destroy');
  	$togglerNew.attr('title', is_new ? 'Quitar nuevo' : 'Marcar como nuevo');
  	$togglerNew.tooltip();
  	$togglerOffer.data('hash', { product: { special: is_offer ? 'is_regular' : 'is_offer' }});
  	$togglerOffer.find('.fa').removeClass('fa-star fa-star-o').addClass(is_offer ? 'fa-star' : 'fa-star-o');
  	$togglerOffer.tooltip('destroy');
  	$togglerOffer.attr('title', is_offer ? 'Quitar oferta' : 'Marcar como oferta');
  	$togglerOffer.tooltip();
  };
	var updatedMany = function(e, response) {
	  for (var key in response) {
	  	updateToggle(e, response[key]);
	  	updateSpecialToggle(e, response[key]);
	  };
	  Alerts.success('Se cambiaron con exito los productos seleccionados');
	};
	var filterable_submit = function(e) {
	  $(this).closest('form').submit();
	};
	$('[data-util=updateMany]').on('updated.util.updateMany', updatedMany);
	$('.product-active-toggler').on('updated.util.update', updateToggle);
	$('.product-new-toggler, .product-offer-toggler').on('updated.util.update', updateSpecialToggle);
	$('#filterable-products select').change(filterable_submit);
	Utils.checkboxes();
	Utils.updateMany();
	Utils.deleteManyForm();
	Utils.selectpicker();
};

Products.show = function() {
	$('#tabs-container>nav>li>a').click(function(e) {
	  e.preventDefault();
	  $(this).tab('show');
	});
	$('#product_active_toggler').on('updated.util.update', function(e, response) {
	  var $this = $(this);
	  var is_active = response.status == 'active';
	  $this.data('hash', { product: { status: is_active ? 'paused' : 'active' }});
	  $this.find('.fa').removeClass('fa-play fa-pause').addClass(is_active ? 'fa-pause' : 'fa-play');
	  $this.tooltip('destroy');
	  $this.attr('title', is_active ? 'Pausar' : 'Activar');
	  $this.tooltip();
	  $('#product_page_link')[(is_active ? 'remove' : 'add') + 'Class']('hidden');
	  $('#product_active_toggler_update')
	  .text(is_active ? 'Activa' : 'Pausada')
	  .removeClass('label-success label-danger label-info')
	  .addClass(is_active ? 'label-success' : 'label-danger');
	});
};

Products.form = function() {
	var validationObject = {
	  rules: {
	    "product[width_mm]": {
	      required: {
	        depends: function(element) {
	          return !!$('#product_height_mm').val().length || !!$('#product_depth_mm').val().length;
	        }
	      }
	    },
	    "product[height_mm]": {
	      required: {
	        depends: function(element) {
	          return !!$('#product_width_mm').val().length || !!$('#product_depth_mm').val().length;
	        }
	      }
	    },
	    "product[depth_mm]": {
	      required: {
	        depends: function(element) {
	          return !!$('#product_width_mm').val().length || !!$('#product_height_mm').val().length;
	        }
	      }
	    }
	  }
	};
	$('form#new_product').validate(validationObject);
	$('form[id^="edit_product"]').validate(validationObject);
	Utils.selectpicker();
	Utils.autonumeric();
	Utils.addOptionToSelect();
	$('#tinymce_tabs a').click(function(e) {
	  e.preventDefault()
	  $(this).tab('show')
	});
	$('#product_currency').change(function(e) {
		var $this = $(this);
		var value = $this.val();
		var $price = $('#product_price');
		if (value == 'ask') $price.attr('disabled', 'disabled').val(null);
		else $price.removeAttr('disabled');
	}).triggerHandler('change');
};