require_relative 'capture'
require 'rake'

class CliWrapperIO < StringIO
  def initialize(*attrs)
    @command_order = attrs.shift
    super(*attrs)
  end

  def gets
    @command_order << [:gets]
    super
  end

  def puts(*attrs)
    @command_order << [:puts] + attrs
    super
  end

  def noecho(*)
    yield self
  end
end

RSpec.shared_context 'cli', cli: :metadata do
  let(:command) { '' }
  let(:__stdout) { CliWrapperIO.new(__command_order) }
  let(:__exit_status) { [] }
  let(:__command_order) { [] }
  let(:inputs) { '' }
  let(:__stdin) { CliWrapperIO.new(__command_order, inputs) }

  def stdout
    @stdout ||= begin
      subject
      __stdout.string
    end
  end

  def exit_status
    @exit_status ||= begin
      subject
      __exit_status.first || 0
    end
  end

  def cmd_order
    @cmd_order ||= begin
      subject
      __command_order
    end
  end

  subject do
    capture_stdin(__stdin) do
      capture_stdout(__stdout) do
        begin
          ARGV.clear
          rake_argv.each do |item|
            ARGV << item
          end
          Rake::Task[command].reenable
          Rake::Task[command].invoke
        rescue SystemExit => e
          __exit_status << e.status
        end
      end
    end
  end
end
