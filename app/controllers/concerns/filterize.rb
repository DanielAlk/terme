module Filterize
	extend ActiveSupport::Concern

	module ClassMethods
	  attr_reader :filterize_defaults

	  private
		  def filterize_default(options={})
		  	if @filterize_defaults.blank?
		  		@filterize_defaults = options
		  	else
		  		@filterize_defaults = @filterize_defaults.merge(options)
		  	end
		  end
  end

	def filterize
		object = self.class.name.sub('Controller', '').singularize.constantize
		collection = object.where(nil)
		if params[:filterable].present?
			if params[:filterable][:scopes].present?
				params[:filterable][:scopes].keys.each do |key|
					scope = params[:filterable][:scopes][key]
					if scope.present?
						if object.column_names.include? key
							collection = collection.where(key => scope)
						else
							collection = collection.where(key.to_s + '_id' => scope)
						end
					end
				end
			end
			collection = collection.fsearch params[:filterable][:search] if params[:filterable][:search].present?
			collection = collection.forder params[:filterable][:order] if params[:filterable][:order].present?
			if params[:filterable][:range].present?
				params[:filterable][:range].keys.each do |key|
					range = params[:filterable][:range][key]
					scope = range[:scope].present? ? range[:scope] : nil
					collection = collection.frange(key, range[:min], range[:max], range[:scope]) if range[:min].present? && range[:max].present?
				end
			end
		end
		if (defaults = self.class.filterize_defaults).present?
			if (order = defaults[:order]).present?
				collection = collection.forder order
			end
		end
		instance_variable_set('@' + object.name.pluralize.downcase, collection)
		@filterable = params[:filterable]
	end
end