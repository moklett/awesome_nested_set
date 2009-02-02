module CollectiveIdea #:nodoc:
  module Acts #:nodoc:
    module NestedSet #:nodoc:
      # This module provides some helpers for the model classes using acts_as_nested_set.
      # It is included by default in all views.
      #
      module Helper
        # Returns options for select.
        # You can exclude some items from the tree.
        # You can pass a block receiving an item and returning the string displayed in the select.
        #
        # == Params
        #  * +class_or_item+ - Class name or top level times
        #  * +mover+ - The item that is being move, used to exlude impossible moves
        #  * +&block+ - a block that will be used to display: { |item| ... item.name }
        #
        # == Usage
        #
        #   <%= f.select :parent_id, nested_set_options(Category, @category) {|i|
        #       "#{'–' * i.level} #{i.name}"
        #     }) %>
        #
        def nested_set_options(class_or_item, mover = nil)
          class_or_item = class_or_item.roots if class_or_item.is_a?(Class)
          items = Array(class_or_item)
          result = []
          items.each do |root|
            result += root.self_and_descendants.map do |i|
              if mover.nil? || mover.new_record? || mover.move_possible?(i)
                [yield(i), i.id]
              end
            end.compact
          end
          result
        end  
        
        # Returns an HTML-formatted version of the given nested set instance (or array of instances).  The default
        # is to create a nested tree via an HTML Unordered List, using the passed in block as the contents for each
        # <li> tag.
        def format_nested_set(item_or_items, options = {}, &block)
          options.reverse_merge!({
            :major => {:tag => :ul, :class => 'tree'},
            :minor => {:tag => :li, :class => nil}
          })
          
          item_or_items = Array(item_or_items)
          
          content = ''
          return content if item_or_items.empty?
          
          item_or_items.each do |i|
            minor_content = yield(i) + format_nested_set(i.children, options, &block)
            content << if options[:minor][:tag]
              content_tag(options[:minor][:tag], minor_content, :class => options[:minor][:class])
            else
              minor_content
            end
          end
          
          if options[:major][:tag]
            content_tag(options[:major][:tag], content, :class => options[:major][:class])
          else
            content
          end
        end
      end
    end  
  end
end