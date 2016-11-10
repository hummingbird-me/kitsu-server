module HTML
  class Pipeline
    class OneboxFilter < HTML::Pipeline::Filter
      def call
        doc.search('a').each do |a|
          preview = Onebox.preview(a['href'], max_width: 500) rescue nil
          a.swap(preview.to_s) if preview&.to_s.present?
        end
        doc
      end
    end
  end
end
