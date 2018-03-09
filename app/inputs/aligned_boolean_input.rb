class AlignedBooleanInput < Formtastic::Inputs::BooleanInput
  def to_html
    input_wrapping do
      label_html <<
      hidden_field_html <<
      check_box_html
    end
  end

  def label_html_options
    {
      :class => super[:class] + ['label'] # re-add 'label' class
    }
  end
end