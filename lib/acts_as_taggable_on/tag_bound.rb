# encoding: utf-8
module ActsAsTaggableOn
  class TagBound < ::ActiveRecord::Base

    ### ASSOCIATIONS:

    belongs_to :tag, class_name: '::ActsAsTaggableOn::Tag'

    ### VALIDATIONS:

    validates_presence_of :class_name
    validates_uniqueness_of :tag_id, scope: :class_name
  end
end
