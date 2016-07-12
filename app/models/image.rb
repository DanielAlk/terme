class Image < ActiveRecord::Base
	has_attached_file :item, styles: { big: "2000x1455#", medium: "1100x800#", small: "500x460#", thumb: "150x110#" }, default_url: "product-imgs/p-:style.jpg"
  validates_attachment :item, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }, size: { less_than: 1.megabytes }
  belongs_to :imageable, polymorphic: true
  acts_as_list scope: :imageable
end
