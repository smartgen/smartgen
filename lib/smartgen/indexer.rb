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
        html_doc = Nokogiri::HTML(@result)
        tags = html_doc.xpath('//h1|//h2|//h3|//h4|//h5|//h6')
        
        current_level = 0
        parent = nil
        tags.each do |h_tag|
          replace_h_tag(h_tag)
          tag_level = tag_level_for(h_tag)

          if tag_level < current_level
            parent = parent_with_level(tag_level, parent)
          elsif tag_level == current_level
            parent = parent[:parent]
          end
          
          parent = add_to(parent, h_tag, tag_level)
          current_level = tag_level
        end
        
        remove_parents_from(index)
      end
      
      def tag_level_for(h_tag)
        h_tag.name.sub('h', '').to_i
      end
      
      def add_to(parent, h_tag, tag_level)
        index_hash(parent, h_tag, tag_level).tap do |child|
          if parent.nil? # add to index
            index << child
          else
            parent[:children] << child
          end
        end
      end
      
      def index_hash(parent, h_tag, tag_level)
        { :text => h_tag.inner_html, :id => h_tag['id'], :level => tag_level, :parent => parent, :children => [] }
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
    
      def replace_h_tag(h_tag)
        snippet = h_tag.to_html
        h_tag['id'] ||= title_to_idx(h_tag.text)
        @result.sub!(snippet, h_tag.to_html)
      end
    
      def title_to_idx(title)
        title.strip.downcase.gsub(/\s+|_/, '-').delete('^a-z0-9-')
      end
  end
end