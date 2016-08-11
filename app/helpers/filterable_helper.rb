module FilterableHelper
	def filterable(*args)
		return nil unless @filterable.present? && args.present?
		return @filterable unless args.present?
		response = @filterable
		args.each do |arg|
			response = response[arg] if response.present?
		end
		response
	end

	def filterable_html_option(content, value, *args)
		'<option '+ (filterable(*args) == value ? 'selected' : '') +' data-content="' + content + '" value="' + value + '"></option>'
	end

	def filterable_select(collection, option, parameter = false, exclude: nil)
		return nil if (options = collection.filterable_options[option.to_sym]).blank?
		response = ''
		case option.to_sym
		when :joins
			options.each do |column|
				value = column.to_s
				if (label = collection.filterable_options[:labels][:joins]).present? && (label = label[column]).present?
					content = label.capitalize
				else
					content = value.capitalize
				end
				response += filterable_html_option(content, value, :joins)
			end
		when :order
			options = options - parameter if parameter.present?
			options.each do |column|
				value = column.to_s
				if (label = collection.filterable_options[:labels][:order]).present? && (label = label[column]).present?
					content = label.capitalize
				else
					content = value.capitalize
				end
				response += filterable_html_option(content + ' <i class=\'fa fa-angle-down fa-fw\'></i>', value + '_asc', :order)
				response += filterable_html_option(content + ' <i class=\'fa fa-angle-up fa-fw\'></i>', value + '_desc', :order)
			end
		when :scopes
			object = collection.name.constantize
			column_names = collection.column_names
			is_belongs_to = column_names.include?(parameter.to_s + '_id')
			column_name = is_belongs_to ? parameter.to_s + '_id' : parameter.to_s
			scope_name = parameter.to_s.pluralize
			labels = collection.filterable_options[:labels][:scopes][parameter] rescue nil
			select_options = []
			if object.respond_to?(scope_name) #its enum
				object.public_send(scope_name).each do |key, value|
					unless exclude.present? && key.to_sym == exclude
						content = (labels[key.to_sym] || key).to_s.capitalize
						value = value.to_s
						select_options << [content, value]
					end
				end
			elsif column_name.present? #its a column
				object.select(column_name).distinct.each do |member|
					value = member[column_name].to_s
					if is_belongs_to
						record = parameter.to_s.capitalize.constantize.find(value.to_i)
						content = (record.respond_to?(:name) ? record.name : record.title).to_s
					else
						content = value.to_s
					end
					select_options << [content, value]
				end
			end
			select_options.each do |content, value|
				response += filterable_html_option(content, value, :scopes, parameter)
			end
		end
		response.html_safe
	end
end
