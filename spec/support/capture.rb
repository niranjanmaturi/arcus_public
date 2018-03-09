require 'byebug'
require 'byebug/interface'
require 'byebug/context'
module Byebug
  class CliInterface < LocalInterface
    def initialize(good_out_stream)
      super()
      @output = good_out_stream
    end
  end
end

module Capture
  %i[stdout stderr stdin].each do |stream|
    define_method("capture_#{stream}") do |io = StringIO.new, &block|
      capture stream, io, &block
    end
  end

  def capture(stream, io, &block)
    orig = eval "$#{stream}"

    Byebug::Context.interface = Byebug::CliInterface.new(orig) if stream == 'stdout'

    eval "$#{stream} = io"
    (block || proc { subject }).call
    io.string
  ensure
    eval "$#{stream} = orig"
  end
end

