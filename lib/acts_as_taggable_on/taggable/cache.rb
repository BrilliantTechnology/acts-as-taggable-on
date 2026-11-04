module ActsAsTaggableOn::Taggable
  module Cache
    # Tag list caching is enabled for any context that has a matching
    # "cached_#{context}_list" column. The column check is done lazily (when
    # the cached list is about to be saved) so that declaring a model taggable
    # does not force a database connection at class load time.
    #
    # Earlier versions intercepted `.columns` to add these methods only once
    # the schema was loaded, but since Rails 7.1 ActiveRecord no longer calls
    # `.columns` while loading the schema, so that hook never fired.
    def self.included(base)
      unless base.include?(InstanceMethods)
        base.send :include, InstanceMethods
        base.extend ClassMethods
        base.before_save :save_cached_tag_list
      end

      # Re-run on every include so contexts added by later acts_as_* calls
      # also get a caching_*_list? predicate.
      base.initialize_tags_cache
    end

    module ClassMethods
      def initialize_tags_cache
        tag_types.map(&:to_s).each do |tag_type|
          define_singleton_method("caching_#{tag_type.singularize}_list?") do
            caching_tag_list_on?(tag_type)
          end
        end
      end

      def caching_tag_list_on?(context)
        column_names.include?("cached_#{context.to_s.singularize}_list")
      end
    end

    module InstanceMethods
      def save_cached_tag_list
        tag_types.map(&:to_s).each do |tag_type|
          next unless self.class.caching_tag_list_on?(tag_type)
          next unless tag_list_cache_set_on(tag_type)

          list = tag_list_cache_on(tag_type).to_a.flatten.compact.join("#{ActsAsTaggableOn.delimiter} ")
          self["cached_#{tag_type.singularize}_list"] = list
        end

        true
      end
    end
  end
end
