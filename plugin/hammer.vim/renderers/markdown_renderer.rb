markup :redcarpet, /md|mkd|markdown|mdwn/ do |content|
  require 'redcarpet'
  
  class Hammer::MarkdownRenderer < Redcarpet::Render::HTML
  end

  renderer = Redcarpet::Markdown.new Hammer::MarkdownRenderer.new,
                                     :tables => true,
                                     :fenced_code_blocks => true,
                                     :auto_linl => true
  renderer.render(content)
end
