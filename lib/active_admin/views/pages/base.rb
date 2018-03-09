module ActiveAdmin
  module Views
    module Pages
      class Base
        def build_flash_messages
          div class: 'flashes' do
            flash_messages.each do |type, message|
              [message].flatten.each do |msg|
                div msg, class: "flash flash_#{type}"
              end
            end
          end
        end
      end
    end
  end
end
