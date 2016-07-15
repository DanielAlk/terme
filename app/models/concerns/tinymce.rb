module Tinymce
  extend ActiveSupport::Concern

  def tinymce_sanitize(argument)
  	sanitizer = Rails::Html::WhiteListSanitizer.new
  	sanitizer.sanitize(argument, tags: self.class.tinymce_tags, attributes: self.class.tinymce_attributes)
  end

  module ClassMethods
  	attr_reader :tinymce_tags
  	attr_reader :tinymce_attributes

  	private
  		def tinymce(columns: [], tags: %w(strong em br a), attributes: %w(href))
  			@tinymce_tags = tags
  			@tinymce_attributes = attributes
  			columns.each do |column|
  				define_method column.to_s + '=' do |argument|
  					write_attribute(column, tinymce_sanitize(argument))			
  				end
  			end
  		end
  end

end