module ProjectsHelper
  ALIGN_LINE = /\A\[align:(left|center|right)\]\z/

  # Renders a project's description as HTML.
  #   "## Heading" on its own line -> bold section header (blank lines around it optional)
  #   "**bold**" / "*italic*"      -> <strong> / <em>
  #   "[align:center]" as a paragraph's first line -> text-align on that paragraph
  #   blank-line-separated text    -> separate paragraphs
  def formatted_description(text)
    return "" if text.blank?

    parts = []
    paragraph = []
    align = nil

    flush_paragraph = lambda do
      content = paragraph.join("\n").strip
      if content.present?
        attrs = align ? { style: "text-align: #{align};" } : {}
        parts << content_tag(:p, inline_markdown(content), **attrs)
      end
      paragraph = []
      align = nil
    end

    text.strip.each_line(chomp: true) do |raw_line|
      line = raw_line.rstrip

      if line.start_with?("## ")
        flush_paragraph.call
        parts << content_tag(:h2, inline_markdown(line.delete_prefix("## ").strip), class: "description-header")
      elsif line.strip.empty?
        flush_paragraph.call
      elsif paragraph.empty? && line.strip =~ ALIGN_LINE
        align = Regexp.last_match(1)
      else
        paragraph << line
      end
    end
    flush_paragraph.call

    safe_join(parts)
  end

  private

  # Escapes the text first, then re-introduces our own trusted <strong>/<em>
  # tags, so user-typed "<" or "&" can't inject markup of their own.
  def inline_markdown(text)
    escaped = ERB::Util.html_escape(text)
    escaped = escaped.gsub(/\*\*(.+?)\*\*/, '<strong>\1</strong>')
    escaped = escaped.gsub(/\*(.+?)\*/, '<em>\1</em>')
    escaped.html_safe
  end
end
