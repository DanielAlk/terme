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
	var updatedMany = function(e, response) {
	  for (var key in response) updateToggle(e, response[key]);
	  Alerts.success('Se cambiaron con exito los productos seleccionados');
	};
	var filterable_submit = function(e) {
	  $(this).closest('form').submit();
	};
	$('[data-util=updateMany]').on('updated.util.updateMany', updatedMany);
	$('.product-active-toggler').on('updated.util.update', updateToggle);
	$('#filterable-products select').change(filterable_submit);
	Utils.checkboxes();
	Utils.updateMany();
	Utils.deleteManyForm();
	Utils.selectpicker();
};

Products.show = function() {
	$('#tabs-container a').click(function(e) {
	  e.preventDefault()
	  $(this).tab('show')
	});
	$('#product_active_toggler').on('updated.util.update', function(e, response) {
	  var $this = $(this);
	  var is_active = response.status == 'active';
	  $this.data('hash', { product: { status: is_active ? 'paused' : 'active' }});
	  $this.find('.fa').removeClass('fa-play fa-pause').addClass(is_active ? 'fa-pause' : 'fa-play');
	  $this.tooltip('destroy');
	  $this.attr('title', is_active ? 'Pausar' : 'Activar');
	  $this.tooltip();
	  $('#product_active_toggler_update')
	  .text(is_active ? 'Activa' : 'Pausada')
	  .removeClass('label-success label-danger label-info')
	  .addClass(is_active ? 'label-success' : 'label-danger');
	});
};

Products.form = function() {
	$('form#new_product, form#edit_prodcut').validate({
	  rules: {
	    "product[width_cm]": {
	      required: {
	        depends: function(element) {
	          return !!$('#product_height_cm').val().length || !!$('#product_depth_cm').val().length;
	        }
	      }
	    },
	    "product[height_cm]": {
	      required: {
	        depends: function(element) {
	          return !!$('#product_width_cm').val().length || !!$('#product_depth_cm').val().length;
	        }
	      }
	    },
	    "product[depth_cm]": {
	      required: {
	        depends: function(element) {
	          return !!$('#product_width_cm').val().length || !!$('#product_height_cm').val().length;
	        }
	      }
	    }
	  }
	});
	Utils.selectpicker();
	Utils.autonumeric();
	Utils.addOptionToSelect();
	$('#tinymce_tabs a').click(function(e) {
	  e.preventDefault()
	  $(this).tab('show')
	});
};