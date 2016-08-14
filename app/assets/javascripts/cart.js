var Cart = {};

Cart.init = function(user_signed_in, dolar) {
	if (!user_signed_in) return Cart.notLoggedIn();
	Cart.dolar = dolar;
	Cart.loadProductPage();
	Cart.update();
};

Cart.update = function() {
	$.ajax({url: '/cart', method: 'get'})
	.done(Cart.checkChanges)
	.done(Cart.save)
	.done(Cart.startTimers)
	.done(Cart.updateHeader)
	.done(Cart.updateProductPage)
	.done(Cart.updateCartPage)
	.done(Cart.updateCheckoutPage)
	.done(Cart.log);
};

Cart.addButton = function() {
	$('#cart-add').click(function(e) {
		e.preventDefault();
		var $this = $(this);
		var data = { product: {} };
		data.product.id = Cart.product.id;
		data.product.quantity = $('#quantity_input').val();
		$.ajax({url: $this.attr('href'), type: 'put', data: data, dataType: 'json'})
		.done(function() {
			Cart.doAlertSuccess = true;
		})
		.done(Cart.update);
	});
};

Cart.checkChanges = function(cart) {
	if (!!Cart.redirectIfChange && (!cart.products || Cart.cart.products.length != cart.products.length)) window.location.href = Cart.redirectIfChange;
	else if (!!Cart.doAlertExpire) Alerts.danger('El producto: <b>' + Cart.doAlertExpire.title + '</b> ya no está tu carrito.<br>Han pasado los 10 minutos.');
	else if (!!Cart.product && !!Cart.cart) {
		if (!cart.items || !cart.items[Cart.product.id]) {
			$('#quantity_input').val(0);
			if (!!Cart.cart.items && !!Cart.cart.items[Cart.product.id]) {
				Alerts.danger('Se eliminó el producto del carrito');
			}
		};
	};
	if (!!cart.items && !!Cart.product && !!cart.items[Cart.product.id] && !!Cart.doAlertSuccess) {
		var quantity = cart.items[Cart.product.id].quantity;
		var units = Number(quantity) > 1 ? quantity + ' unidades' : quantity + ' unidad';
		Alerts.success('Ahora tienes '+units+' de este producto en tu carrito.<br>Permanecerá en tu carrito por 10 minutos.<br>¡Confirmá tu compra!');
	};
	Cart.doAlertExpire = false;
	Cart.doAlertSuccess = false;
	Cart.redirectIfChange = false;
};

Cart.updateHeader = function(cart){
	cart.ctotal = Cart.toCurrency(cart.total);
	$('header .cart_count').text(cart.count);
	$('header .cart_price').text(cart.ctotal);
};

Cart.notLoggedIn = function() {
	var $json = $('#productJSON');
	if (!$json.length) return;
	Cart.product = JSON.parse($json.html());
	Cart.quantityPicker(Cart.product.stock);
};

Cart.loadProductPage = function() {
	var $json = $('#productJSON');
	if (!$json.length) return;
	Cart.product = JSON.parse($json.html());
	Cart.addButton();
	Cart.quantityPicker();
	Cart.keepCheckingStock();
};

Cart.checkStock = function() {
	if (!$('#productJSON').length) return clearInterval(Cart.interval);
	$.ajax({url: '/cart/stock', method: 'get', data: { product: Cart.product }, dataType: 'json' })
	.done(function(product) {
		Cart.product.stock = product.stock;
		$('#stock_available').text(product.stock);
	})
	.done(Cart.log);
};

Cart.keepCheckingStock = function() {
	Cart.interval = setInterval(Cart.checkStock, 60000);
};

Cart.updateProductPage = function(cart) {
	if (!!Cart.product) Cart.checkStock();
	if (!cart.items || !Cart.product) return;
	var product = Cart.product;
	var item = cart.items[product.id];
	if (!item) return;
	$('#quantity_input').val(item.quantity);
};

Cart.updateCartPage = function(cart) {
	var $table = $('table#cartTable');
	if (!$table.length) return;
	var $counters = $('[data-expires]');
	var $quantity_inputs = $('tbody tr .qty');
	var $removers = $('tbody tr .removeFromCart');
	var $rows = $table.find('tbody tr');
	if (!Cart.cart.items) {
		$rows.fadeOut(function() { $rows.remove(); });
		$table.find('thead').hide();
		$table.find('tbody').append($('<div>', { text: 'Tu carrito de compras está vacio.' }));
	}	else $rows.each(function() {
		var $row = $(this);
		var id = $row.attr('id').replace('product-', '');
		if (!Cart.cart.items[id]) $row.fadeOut(function() { $row.remove(); });
	});
	$counters.each(Cart.counter);
	$quantity_inputs.each(Cart.cartPageQuantity);
	$removers.each(Cart.cartPageRemovers);
	Cart.checkoutButton();
	Cart.cartToPage();
};

Cart.cartToPage = function() {
	var items = Cart.cart.items;
	var count = Cart.cart.count;
	var total = 0;
	for (var id in items) {
		var item = items[id];
		var product = Cart.getProduct(id);
		var price = product.currency == 'u$s' ? product.price * Cart.dolar : product.price;
		var subtotal = Number(price) * Number(item.quantity);
		$('#product-' + id + ' .subtotal-product').text(Cart.toCurrency(subtotal));
		$('#quantity-' + id).val(item.quantity);
		total += subtotal;
	};
	$('#cartTotal').text(Cart.toCurrency(total));
	$('#cartItems').text(count + (count > 1 ? ' items' : ' item'));
	Cart.cart.total = total;
};

Cart.checkoutButton = function() {
	var $checkout = $('#cartCheckout');
	if (!$checkout.length || $checkout.data('cart-checkout')) return;
	$checkout.click(function(e) {
		e.preventDefault();
		if (!Cart.cart.items) return Alerts.danger('Tu carrito está vacio.');
		var href = $checkout.attr('href');
		var items = Cart.cart.items;
		var data = {};
		data.products = [];
		for (var id in items) {
			var item = items[id];
			var product = { id: id, quantity: item.quantity };
			data.products.push(product);
		};
		$.ajax({url: '/cart/add', type: 'put', data: data, dataType: 'json'})
		.done(function() {
			window.location.href = href;
		});
	});
	$checkout.data('cart-checkout', true);
};

Cart.cartPageRemovers = function() {
	if ($(this).data('cart-remover')) return;
	var $remover = $(this);
	var $item = $remover.closest('tr');
	var id = $item.attr('id').replace('product-', '');
	$remover.click(function(e) {
		e.preventDefault();
		$.ajax({url: '/cart/remove', type: 'put', data: { product: { id: id } }, dataType: 'json'})
		.done(function() {
			$item.fadeOut(function() { $item.remove(); });
		})
		.done(Cart.update);
	});
	$remover.data('cart-remover', true);
};

Cart.cartPageQuantity = function() {
	if ($(this).data('cart-quantity')) return;
	var $el = $(this);
	var $parent = $el.parent();
	var product_stock = $el.data('stock');
	var id = $el.attr('id').replace('quantity-', '');
	var change = function(e) {
		var stock = product_stock;
		var amt = e == 1 || e == -1 ? e : ($(this).hasClass('mas') ? 1 : -1);
    var val = parseInt($el.val(),10) + amt;
    val = val >= 1 ? val : $el.val();
    val = val <= stock ? val : stock;
    val = !!Number(val) ? val : 1;
    Cart.cart.items[id].quantity = val;
    Cart.cartToPage();
  };
  var keydownHandler = function(e) {
    switch(e.which) {
      case 38: change(1); break;
      case 40: change(-1); break;
      case 37: case 39: case 16: case 17: case 18: case 8: case 13: case 46: break;
      default: if (!Number(String.fromCharCode(e.which)) && Number(String.fromCharCode(e.which)) != 0) e.preventDefault();
    };
  };
  var focusoutHandler = function(e) {
  	var stock = product_stock;
    if (!Number($el.val())) $el.val(0);
    if (Number($el.val()) > stock) $el.val(stock);
  };
  $parent.find('.mas').click(change);
  $parent.find('.menos').click(change);
  $parent.disableSelection();
  $el.keydown(keydownHandler).focusout(focusoutHandler);
  $el.data('cart-quantity', true);
};

Cart.updateCheckoutPage = function() {
	if (!$('#cartCheckoutConfirmation').length) return;
	var $counters = $('[data-expires]');
	Cart.redirectIfChange = $counters.data('href');
	$counters.each(Cart.counter);
};

Cart.counter = function() {
	if ($(this).data('cart-counter')) return;
	var $counter = $(this);
	var start = new Date().getTime();
	var elapsed = '0';
	var expiration = $counter.data('expires');
	var minutes, seconds;
	var frame = function() {
		var time = new Date().getTime() - start;
		elapsed = Math.round(Math.floor(time / 100) / 10);
		expires = expiration - elapsed;
		minutes = Math.floor(expires / 60);
		seconds = expires - (minutes * 60);
		if (seconds < 10) seconds = '0' + seconds;
		$counter.text(minutes + ':' + seconds);
	};
	window.setInterval(frame, 500);
	$counter.data('cart-counter', true);
};

Cart.getProduct = function(id) {
	if (!Cart.cart || !Cart.cart.products) return false;
	var product;
	Cart.cart.products.forEach(function(p) {
		if (p.id == id) product = p;
	});
	return product;
};

Cart.startTimers = function(cart) {
	if (!!Cart.timers) {
		Cart.timers.forEach(function(timer) {
			clearTimeout(timer.tic);
		});
	};
	Cart.timers = [];
	for (var id in cart.items) {
		Cart.timers.push(new Cart.Timer(id));
	};
};

Cart.Timer = function(id) {
	cart = Cart.cart;
	this.tic = setTimeout(function() {
		Cart.doAlertExpire = Cart.getProduct(id);
		Cart.update();
	}, cart.items[id].expires_in * 1000);
	return this;
};

Cart.save = function(cart) {
	Cart.cart = cart;
};

Cart.quantityPicker = function(product_stock) {
	product_stock = product_stock || Cart.product.stock;
	var $el = $('.qty');
	var change = function(e) {
		var stock = product_stock;
		var amt = e == 1 || e == -1 ? e : ($(this).hasClass('mas') ? 1 : -1);
    var val = parseInt($el.val(),10) + amt;
    val = val >= 0 ? val : $el.val();
    val = val <= stock ? val : stock;
    val = !!Number(val) ? val : 0;
    $el.val(val);
  };
  var keydownHandler = function(e) {
    switch(e.which) {
      case 38: change(1); break;
      case 40: change(-1); break;
      case 37: case 39: case 16: case 17: case 18: case 8: case 13: case 46: break;
      default: if (!Number(String.fromCharCode(e.which)) && Number(String.fromCharCode(e.which)) != 0) e.preventDefault();
    };
  };
  var focusoutHandler = function(e) {
  	var stock = product_stock;
    if (!Number($el.val())) $el.val(0);
    if (Number($el.val()) > stock) $el.val(stock);
  };
  $('#quantity .mas').click(change);
  $('#quantity .menos').click(change);
  $('#quantity').disableSelection();
  $el.keydown(keydownHandler).focusout(focusoutHandler);
  $('#quantity').closest('form').submit(function(e) {e.preventDefault()});
};

Cart.toCurrency = function(number) {
	return '$ ' + Number(number).toFixed(2).replace('.', ',').replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1.");
};

Cart.log = function() {
	//console.log(arguments, Cart.cart);
};