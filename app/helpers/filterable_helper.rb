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

	def filterable_select(collection, option, scoped = false)
		return nil if (options = collection.filterable_options[option.to_sym]).blank?
		response = ''
		case option.to_sym
		when :order
			options.each do |o|
				if (label = collection.filterable_labels[:order]).present? && (label = label[o]).present?
					content = label
				else
					content = o.to_s.capitalize
				end
				response += '<option '+ (filterable(:order) == o.to_s + '_asc' ? 'selected' : '') +' data-content="' + content + ' &darr;" value="' + o.to_s + '_asc"></option>'
				response += '<option '+ (filterable(:order) == o.to_s + '_desc' ? 'selected' : '') +' data-content="' + content + ' &uarr;" value="' + o.to_s + '_desc"></option>'
			end
		when :scopes
			column = collection.column_names.include?(scoped.to_s) ? scoped.to_s : false
			column = !column && collection.column_names.include?(scoped.to_s + '_id') ? scoped.to_s + '_id' : scoped.to_s
			if column.present?
				collection.name.constantize.select(column).distinct.each do |d|
					value = d[column].to_s
					if collection.name.constantize.respond_to?(scoped.to_s.pluralize)
						id = value
						value = collection.name.constantize.public_send(scoped.to_s.pluralize).keys[value.to_i]
					elsif collection.column_names.include?(scoped.to_s + '_id')
						id = value
						record = scoped.to_s.capitalize.constantize.find(id.to_i)
						value = record.respond_to?(:name) ? record.name : record.title
					else
						id = value
					end
					if (labels = collection.filterable_labels[:scopes]).present? && (labels = labels[scoped.to_sym]).present?
						value = labels[value.to_sym].to_s
					end
					response += '<option '+ (filterable(:scopes, scoped) == id ? 'selected' : '') +' data-content="' + value + '" value="' + id + '"></option>'
				end
			end
		end
		response.html_safe
	end
end
