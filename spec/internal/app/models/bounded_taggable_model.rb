class BoundedTaggableModel < ActiveRecord::Base
  acts_as_bounded_ordered_taggable_on :languages
end
