module Filterize
	extend ActiveSupport::Concern

	module ClassMethods
	  attr_reader :filterize_options

	  private
		  def filterize(options={})
		  	if @filterize_options.blank?
		  		@filterize_options = options
		  	else
		  		@filterize_options = @filterize_options.merge(options)
		  	end
		  end
  end

	def filterize
		object = self.class.filterize_options[:object].to_s.titlecase.constantize rescue false
		object = object || self.class.name.sub('Controller', '').singularize.constantize
		collection = object.where(nil)
		if params[:filterable].present?
			if params[:filterable][:scopes].present?
				params[:filterable][:scopes].keys.each do |key|
					if (scope = params[:filterable][:scopes][key]).present?
						if object.respond_to? key.to_s.pluralize #is enum
							collection = collection.public_send(object.public_send(key.to_s.pluralize).key(scope.to_i))
						elsif object.column_names.include?(key.to_s + '_id')
							collection = collection.where(key.to_s + '_id' => scope)
						else
							collection = collection.where(key => scope)
						end
					end
				end
			end
			collection = collection.fsearch params[:filterable][:search] if params[:filterable][:search].present?
			collection = collection.forder params[:filterable][:order] if params[:filterable][:order].present?
			collection = collection.joins(params[:filterable][:joins].to_sym).distinct if params[:filterable][:joins].present?
			if params[:filterable][:range].present?
				params[:filterable][:range].keys.each do |key|
					range = params[:filterable][:range][key]
					scope = range[:scope].present? ? range[:scope] : nil
					collection = collection.frange(key, range[:min], range[:max], range[:scope]) if range[:min].present? || range[:max].present?
				end
			end
		end
		if (defaults = self.class.filterize_options).present?
			if (order = defaults[:order]).present?
				collection = collection.forder order
			end
			if (scope = defaults[:scope]).present?
				collection = collection.send(scope.to_s)
			end
		end
		instance_variable_set('@' + object.name.pluralize.downcase, collection)
		@filterable = params[:filterable]
	end
end