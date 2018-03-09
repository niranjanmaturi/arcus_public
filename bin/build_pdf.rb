#!/usr/bin/env ruby

require 'kramdown'
require 'active_support/all'

PAGE_BREAK = '@@NEWPAGE@@'

module Kramdown
  module Converter
    class Pdf
      alias convert_orig convert

      def convert(el, opts = {})
        if el.value == PAGE_BREAK
          @pdf.start_new_page
          nil
        else
          convert_orig(el, opts)
        end
      end

      alias header_options_orig header_options
      def header_options(el, opts)
        opts[:align] = el.attr['align'].to_sym if el.attr['align']
        header_options_orig(el, opts)
      end

      alias p_options_orig p_options
      def p_options(el, opts)
        result = p_options_orig(el, opts)
        result[:align] = el.attr['align'].to_sym if el.attr['align']
        result
      end

      alias render_codeblock_orig render_codeblock
      def render_codeblock(el, opts)
        el.value = el.value.gsub(/^([^\S\r\n]+)/m) { |m| "\xC2\xA0" * m.size }
        render_codeblock_orig(el, opts)
      end

      def codeblock_options(_, opts)
        {
          font: 'Courier',
          size: 8,
          color: '009900',
          bottom_padding: opts[:size]
        }
      end

      def codespan_options(el, opts)
        {
          font: 'Courier',
          size: 8,
          color: '009900'
        }
      end

      def render_table(el, opts)
        data = []
        el.children.each do |container|
          container.children.each do |row|
            data << []
            row.children.each do |cell|
              if cell.children.any? {|child| child.options[:category] == :block}
                line = el.options[:location]
                warning("Can't render tables with cells containing block elements#{line ? " (line #{line})" : ''}")
                return
              end
              cell_data = inner(cell, opts)
              if cell_data.size == 1
                new_cell_data = {}
                cell_data = cell_data[0]

                new_cell_data[:content] = "<font size='#{cell_data[:size] || 12}' name='#{cell_data[:font] || 'Helvetica'}'>"
                new_cell_data[:content] += "<color rgb='#{cell_data[:color] || '000000'}'>"
                new_cell_data[:content] += cell_data.delete(:text).gsub('<', '&lt;').gsub('>', '&gt;')
                new_cell_data[:content] += "</color></font>"
                new_cell_data[:inline_format] = true
                data.last << @pdf.make_cell(new_cell_data)
              else
                data.last << cell_data.map {|c| c[:text]}.join('')
              end
            end
          end
        end
        with_block_padding(el, opts) do
          @pdf.table(data, :width => @pdf.bounds.right) do
            el.options[:alignment].each_with_index do |alignment, index|
              columns(index).align = alignment unless alignment == :default
            end
          end
        end
      end
    end
  end
end

Prawn::Font::AFM.hide_m17n_warning = true

def intro?(filename)
  File.basename(filename).start_with?('000_')
end

def header_depth(header)
  header[0].gsub(/^\#/, '').gsub(/./, '  ') + '*'
end

def header_name(header)
  header[1].strip
end

def header_link(header)
  # Code here copied from kramdown
  gen_id = header[1].gsub(/^[^a-zA-Z]+/, '')
  gen_id.tr!('^a-zA-Z0-9 -', '')
  gen_id.tr!(' ', '-')
  gen_id.downcase!
  gen_id
end

PAGE_BREAK_SEP = "\n\n" + PAGE_BREAK + "\n\n"

files_all = Dir.glob(File.join(File.dirname(__FILE__), '..', 'doc_src', '*.md')).sort
files_intro = files_all.select { |f| intro? f }
files_body = files_all.reject { |f| intro? f }

text_intro = files_intro.map { |f| File.open(f).read }.join(PAGE_BREAK_SEP)
text_body = files_body.map { |f| File.open(f).read }.join(PAGE_BREAK_SEP)

headers = text_body.scan(/^(#+)\s+(.+)$/)
table_of_contents = headers.map { |h| header_depth(h) + ' [' + header_name(h) + '](#' + header_link(h) + ')' }.join(?\n)


contents = text_intro + "\n\n" + table_of_contents + PAGE_BREAK_SEP + text_body

filename = ARGV.shift

output = Kramdown::Document.new(contents, input: :kramdown).to_pdf
if filename
  File.open(filename, 'w+') { |f| f.write output }
else
  puts output
end
