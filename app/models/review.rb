class Review < ActiveRecord::Base
  belongs_to :reviewer, polymorphic: true
  belongs_to :reviewable, polymorphic: true
end
