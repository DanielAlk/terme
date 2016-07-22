var Cart = {};

Cart.init = function(user_signed_in) {
	if (!user_signed_in) return Cart.notLoggedIn();
	Cart.loadProductPage();
	Cart.update();
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
	if (!!Cart.product && !!Cart.cart) {
		if (!cart.items || !cart.items[Cart.product.id]) {
			$('#quantity_input').val(0);
			if (!!Cart.cart.items && !!Cart.cart.items[Cart.product.id]) {
				if (!!Cart.doAlertExpire) Alerts.danger('El producto: <b>' + Cart.doAlertExpire.title + '</b> ya no está tu carrito.<br>Han pasado los 10 minutos.');
				else Alerts.danger('Se eliminó el producto del carrito');
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
};

Cart.update = function() {
	$.ajax({url: '/cart', method: 'get'})
	.done(Cart.checkChanges)
	.done(Cart.save)
	.done(Cart.startTimers)
	.done(Cart.updateHeader)
	.done(Cart.updateProductPage)
	.done(Cart.log);
};

Cart.updateHeader = function(cart){
	cart.ctotal = '$ ' + Number(cart.total).toFixed(2).replace('.', ',').replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1.");
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

Cart.getProduct = function(id) {
	if (!Cart.product || !Cart.cart || !Cart.cart.products) return false;
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

Cart.log = function() {
	//console.log(arguments, Cart.cart);
};