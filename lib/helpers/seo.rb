module Helpers
  module Seo
    def valid_description?(description)
      return false if description.length > 155
      return false if description =~ /['"]/
      return true
    end

    def description_seo
      description = nil

      if data.page.description
        description = data.page.description
      elsif content_for?(:page_description)
        description = content_for(:page_description)
      end

      if description
        if valid_description?(description)
          content_tag :meta, nil, name: 'description', content: description
        else
          content_tag :script, "alert('Please review your description. Length: #{description.length}');", type: 'text/javascript'
        end
      else
        content_tag :script, "alert('this page doesn\\'t provide a description, fix it!');", type: 'text/javascript'
      end
    end

    def title_seo
      if data.page.title
        content_tag :title, data.page.title
      elsif content_for?(:page_title)
        content_tag :title, yield_content(:page_title)
      else
        content_tag :script, "alert('this page doesn\\'t provide a title, fix it!');", type: 'text/javascript'
      end
    end
  end
end