module Hammer

  class << self

    #
    # @return [Array<String>]
    #   List of dependencies required for Hammer to boot.
    #
    def dependencies
      @dependencies ||=
      [
        "rubygems",
        "hammer/env" ,
        "vim/improvedbuffer",
        "erb",
        "shellwords",
        "github/markup",
        "tilt"
      ]
    end

    #
    # @return [Boolean]
    #   Could hammer load all its dependencies?
    #
    def dependencies_met?
      dependencies == met_dependencies
    end

    #
    # @return [Array<String>]
    #   A list of dependencies hammer could load successfully.
    #
    def met_dependencies
      @met_depedencies ||= []
    end

    #
    # Loads all dependencies from {dependencies}.
    #
    # @return [void]
    #
    def load_dependencies!
      dependencies.each do |dependency|
        begin
          require(dependency)
        rescue LoadError
        else
          met_dependencies << dependency
        end
      end
    end

    #
    # Loads all renderers present in {Hammer::ENV.renderers_path}.
    #
    # @return [void]
    #
    def load_renderers!
      return nil unless dependencies_met?
      glob = File.join(Hammer::ENV.renderers_path, "*.rb")

      Dir[glob].each do |renderer|
        to_ruby = File.read(renderer)
        GitHub::Markup.instance_eval(to_ruby)
      end
    end

    #
    # @return [Array<String>]
    #   A list of dependencies hammer cannot load.
    #
    def missing_dependencies
      dependencies - met_dependencies
    end

    #
    # @param [String] path
    #   The path to a file to open with {Hammer::ENV.browser}
    #
    # @return [void]
    #
    def open_browser path
      browser_path = Shellwords.escape(Hammer::ENV.browser)
      browser_args = Hammer::ENV.browser_args
      file_path    = Shellwords.escape(path)

      Vim.command "silent ! #{browser_path} #{browser_args} #{file_path}"
      Vim.command "redraw!"
    end

    #
    # Converts the contents of the buffer to HTML, and displays them in a
    # browser.
    #
    # @param [Vim::ImprovedBuffer]
    #   A {Vim::ImprovedBuffer} object.
    #
    # @return [void]
    #
    def render! buffer
      unless dependencies_met?
        msg = "Hammer is missing dependenices: #{missing_dependencies.join(', ')}"
        Vim.message(msg)
        return nil
      end

      unless GitHub::Markup.can_render?(buffer.basename)
        msg = "Cannot render '#{buffer.extname}' files. Missing renderer?"
        Vim.message(msg)
        return nil
      end

      path = File.join Hammer::ENV.directory, "#{buffer.basename}.html"

      File.open path, 'w' do |f|
        tilt = Tilt.new(Hammer::ENV.template)
        output = tilt.render do
          GitHub::Markup.render(buffer.basename, buffer[1..-1])
        end

        f.write(output)
      end

      Hammer.open_browser path
    end

  end

end
