var Cart = {};

Cart.init = function() {
	Cart.update();
	Cart.addButton();
};

Cart.addButton = function() {
	$('#cart-add').click(function(e) {
		e.preventDefault();
		var $this = $(this);
		var data = { product: {} };
		data.product.id = $this.data('id');
		data.product.quantity = $('#quantity_input').val();
		if (data.product.quantity == 0 || data.product.quantity == '0') Cart.productDeletePage(data.product.id);
		$.ajax({url: $this.attr('href'), type: 'put', data: data, dataType: 'json'})
		.done(Cart.update);
	});
};

Cart.productDeletePage = function(product_id) {
	var $stock = $('#stock_available');
	var item = Cart.cart.items[product_id];
	var stock = Number($stock.text()) + Number(item.quantity);
	$('#quantity_input').val(0);
	$stock.text(stock);
};

Cart.update = function() {
	$.ajax({url: '/cart', method: 'get'})
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

Cart.updateProductPage = function(cart) {
	if (!cart.items) return;
	var product;
	var product_id = $('#cart-add').data('id');
	var item = cart.items[product_id];
	cart.products.forEach(function(p) {
		if (p.id == product_id) product = p;
	});
	if (!item || !product) return;
	$('#quantity_input').val(item.quantity);
	$('#stock_available').text(product.stock);
};

Cart.startTimers = function(cart) {
	if (!!Cart.timers) {
		Cart.timers.forEach(function(timer) {
			clearInterval(timer.tic);
		});
	};
	Cart.timers = [];
	for (var id in cart.items) {
		Cart.timers.push(new Cart.Timer(id));
	};
};

Cart.Timer = function(id) {
	cart = Cart.cart;
	this.tic = setInterval(function() {
		console.log(cart.items[id]);
		cart.items[id].expires_in -= 10;
		if (cart.items[id].expires_in < 1) {
			Cart.productDeletePage(id);
			Cart.update();
		};
	}, 10000);
	return this;
};

Cart.save = function(cart) {
	Cart.cart = cart;
};

Cart.log = function() {
	console.log(arguments);
};