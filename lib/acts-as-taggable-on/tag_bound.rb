# frozen_string_literal: true

module ActsAsTaggableOn
  class TagBound < ::ActiveRecord::Base
    belongs_to :tag, class_name: "::ActsAsTaggableOn::Tag"
    validates_presence_of :class_name
    validates_uniqueness_of :tag_id, scope: :class_name
  end
end
