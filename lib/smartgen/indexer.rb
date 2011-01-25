require 'nokogiri'

module Smartgen
  class Indexer
    def initialize(contents, options={})
      @contents = contents
      @result = contents.dup
      @options = options.is_a?(Hash) ? options : {}
    end
    
    def result
      html_doc = Nokogiri::HTML(@result)
      
      html_doc.css('h1, h2, h3, h4, h5, h6').each do |h_tag|
        snippet = h_tag.to_html
        h_tag['id'] ||= title_to_idx(h_tag.text)
        @result.sub!(snippet, h_tag.to_html)
      end
      
      @result
    end
    
    private
      def title_to_idx(title)
        title.strip.downcase.gsub(/\s+|_/, '-').delete('^a-z0-9-')
      end
  end
end