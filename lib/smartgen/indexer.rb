require 'nokogiri'

module Smartgen
  class Indexer
    attr_accessor :index, :result
    
    def initialize(contents, options={})
      @contents = contents
      @result = @contents.dup
      @options = options.is_a?(Hash) ? options : {}
      @index = []
      
      parse
    end
    
    private
      def parse
        current_level = 0
        parent = nil

        Nokogiri::HTML(@result).xpath('//h1|//h2|//h3|//h4|//h5|//h6').each do |h_tag|
          tag_level = tag_level_for(h_tag)

          if tag_level < current_level
            parent = parent_with_level(tag_level, parent)
          elsif tag_level == current_level
            parent = parent[:parent]
          end
          
          title = h_tag.inner_html
          
          update_h_tag(h_tag, parent)
          parent = add_to(parent, title, tag_level)
          
          current_level = tag_level
        end
        
        remove_parents_from(index)
      end
      
      def tag_level_for(h_tag)
        h_tag.name.sub('h', '').to_i
      end
      
      def add_to(parent, title, tag_level)
        index_hash(parent, title, tag_level).tap do |child|
          if parent.nil? # add to index
            index << child
          else
            parent[:children] << child
          end
        end
      end
      
      def index_hash(parent, title, tag_level)
        return {
          :text => title,
          :id => title_to_idx(title),
          :level => tag_level,
          :parent => parent,
          :children => []
        }.merge(numbered_index_data(parent))
      end
      
      def numbered_index_data(parent)
        if numbered_index?
          { :numbered_index => numbered_index_for(parent) }
        else
          {}
        end
      end
      
      def numbered_index_for(parent)
        if parent.nil?
          "#{index.size + 1}"
        else
          "#{parent[:numbered_index]}.#{parent[:children].size + 1}"
        end
      end
      
      def numbered_index?
        @options[:numbered_index].present?
      end
      
      def parent_with_level(level, current_parent)
        while current_parent.present? && current_parent[:level] >= level
          current_parent = current_parent[:parent]
        end
        
        current_parent
      end
      
      def remove_parents_from(items)
        items.each do |item|
          item.delete(:parent)
          remove_parents_from(item[:children])
        end
      end
    
      def update_h_tag(h_tag, parent)
        snippet = h_tag.to_html
        h_tag['id'] ||= title_to_idx(h_tag.inner_html)
        h_tag.inner_html = "#{numbered_index_for(parent)} #{h_tag.inner_html}" if numbered_index?
        @result.sub!(snippet, h_tag.to_html)
      end
    
      def title_to_idx(title)
        title.strip.downcase.gsub(/\s+|_/, '-').delete('^a-z0-9-')
      end
  end
end