var ArticleExpansible = {};

ArticleExpansible.init = function() {
	$.fn.articleExpansible = ArticleExpansible.extension;
};

ArticleExpansible.extension = function(callback) {
	this.each(function() {
		ArticleExpansible.plugin.call(this, callback)
	});
	return this;
};

ArticleExpansible.plugin = function() {
	var article = this;
  var $article = $(this);
  var $trigger = $article.find('.expansible-trigger');
  var $expansible = $article.find('.expansible');
  var $window = $(window);
  var expansible_height;
  var getHeight = function() {
    expansible_height = $expansible.height();
    if (expansible_height > 190) $expansible.css('height', expansible_height).addClass('contracted');
    else $trigger.hide();
  };
  var triggerClick = function(e) {
    e.preventDefault();
    var text = $trigger.text();
    $expansible.toggleClass('contracted');
    $trigger.text($trigger.data('alt'));
    $trigger.data('alt', text);
  };
  $article.removeClass('article-expansible');
	$trigger.click(triggerClick);
  setTimeout(getHeight, 200);
};

$(ArticleExpansible.init);