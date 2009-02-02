require File.dirname(__FILE__) + '/../test_helper'

module CollectiveIdea
  module Acts #:nodoc:
    module NestedSet #:nodoc:
      class AwesomeNestedSetTest < Test::Unit::TestCase
        include Helper
        include ActionView::Helpers::TagHelper
        fixtures :categories
        
        def test_nested_set_options
          expected = [
            [" Top Level", 1],
            ["- Child 1", 2],
            ['- Child 2', 3],
            ['-- Child 2.1', 4],
            ['- Child 3', 5],
            [" Top Level 2", 6]
          ]
          actual = nested_set_options(Category) do |c|
            "#{'-' * c.level} #{c.name}"
          end
          assert_equal expected, actual
        end
        
        def test_nested_set_options_with_mover
          expected = [
            [" Top Level", 1],
            ["- Child 1", 2],
            ['- Child 3', 5],
            [" Top Level 2", 6]
          ]
          actual = nested_set_options(Category, categories(:child_2)) do |c|
            "#{'-' * c.level} #{c.name}"
          end
          assert_equal expected, actual
        end
        
        def test_format_nested_set_with_roots
          expected = %{<ul class="tree"><li>Top Level<ul class="tree"><li>Child 1</li><li>Child 2<ul class="tree"><li>Child 2.1</li></ul></li><li>Child 3</li></ul></li><li>Top Level 2</li></ul>}
          actual = format_nested_set(Category.roots) {|c| c.name}
          assert_dom_equal expected, actual
        end
        
        def test_format_nested_set_with_first_root
          expected = %{<ul class="tree"><li>Top Level<ul class="tree"><li>Child 1</li><li>Child 2<ul class="tree"><li>Child 2.1</li></ul></li><li>Child 3</li></ul></li></ul>}
          actual = format_nested_set(Category.root) {|c| c.name}
          assert_dom_equal expected, actual
        end
        
        def test_format_nested_set_with_class_options
          expected = %{<ul><li class="leaf">Top Level<ul><li class="leaf">Child 1</li><li class="leaf">Child 2<ul><li class="leaf">Child 2.1</li></ul></li><li class="leaf">Child 3</li></ul></li></ul>}
          actual = format_nested_set(Category.root, :major => {:tag => :ul, :class => nil}, :minor => {:tag => :li, :class => 'leaf'}) {|c| c.name}
          assert_dom_equal expected, actual
        end
        
        def test_format_nested_set_with_custom_tags
          expected = %{<div><span>Top Level<div><span>Child 1</span><span>Child 2<div><span>Child 2.1</span></div></span><span>Child 3</span></div></span></div>}
          actual = format_nested_set(Category.root, :major => {:tag => :div}, :minor => {:tag => :span}) {|c| c.name}
          assert_dom_equal expected, actual
        end
        
      end
    end
  end
end