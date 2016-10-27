module ArticlesHelper
	def article_link_options(link)
		options = [
			['Home'],
			['Productos', products_page_path],
			['Partners', partners_page_path],
			['La Empresa', about_page_path],
			['Noticias', news_page_path],
			['Contacto', contact_page_path]
		]
		unless [nil, products_page_path, partners_page_path, about_page_path, news_page_path, contact_page_path].include? link
			options << [link, link]
		end
		options
	end
end
