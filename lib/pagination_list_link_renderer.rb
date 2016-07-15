module PaginationHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer

    protected

      def page_number(page)
        unless page == current_page
          tag(:li, link(page, page, :rel => rel_value(page)))
        else
          tag(:li, link(page, 'javascript:void(0)'), :class => "active")
        end
      end

      def previous_or_next_page(page, text, classname)
        classname = classname == 'previous_page' ? 'prev' : 'next'
        if page
          tag(:li, link(tag(:span, text), page), :class => classname)
        else
          tag(:li, tag(:span, text), :class => classname + ' disabled')
        end
      end

      def html_container(html)
        tag(:ul, html, class: 'paginadores')
      end

  end
end