module Vim

  module ImprovedBuffer

    #
    # Adds a more Ruby-like interface to Vim::Buffer#[].
    #
    # @param  [Fixnum, Range] key
    # @return [String]
    #
    def [] key
      if key.is_a? Range
        bufsize  = self.count
        key      = bufsize - (key.begin).abs .. key.end if key.begin < 0
        key      = key.begin .. bufsize - (key.end).abs if key.end < 0

        key.map { |number| super(number) }.join "\n"
      else
        super(number)
      end
    end

    # @return [String] Returns the filename of the buffer.
    def basename
      File.basename self.name.to_s
    end

    # @return [String] Returns the file extension of the buffer.
    def extname
      File.extname self.name.to_s
    end

    # @return [Boolean] Returns true if the buffer has been saved to disk.
    def saved?
      File.exist? self.name.to_s
    end

  end

end
