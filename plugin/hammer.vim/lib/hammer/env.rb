module Hammer::ENV

  class << self
    def [] key
      self.send key
    end

    def template
      filename  = Vim.evaluate('g:HAMMER_TEMPLATE') + '.html.erb' 
      @template = File.join(template_path, filename) 
    end

    def directory
      @directory = Vim.evaluate 'g:HAMMER_DIRECTORY'
    end

    def browser 
      @browser = Vim.evaluate 'g:HAMMER_BROWSER'
    end

    def browser_args
      @browser_args = Vim.evaluate 'g:HAMMER_BROWSER_ARGS'
    end

    def commands_path
      @commands_path ||= File.join(install_path, "commands")
    end

    def renderers_path
      @renderers_path ||= File.join(install_path, "renderers")
    end

    def install_path
      @install_path  ||= Vim.evaluate 'g:HAMMER_INSTALL_PATH'
    end

    def template_path
      @template_path ||= File.join(install_path, 'templates')
    end

    def assets_path
      @assets_path ||= File.join(install_path, 'assets')
    end

    def stylesheet_path
      @stylesheet_path ||= File.join(assets_path, 'stylesheets')
    end

    def silence_warnings?
      Vim.evaluate('g:HAMMER_SILENCE_WARNINGS') == 1
    end
  end

end
