def serializers_of(model)
  model.columns.select do |column|
    model.type_for_attribute(column.name).is_a?(::ActiveRecord::Type::Serialized)
  end.inject({}) do |hash, column|
    hash[column.name.to_s] = model.type_for_attribute(column.name).coder
    hash
  end
end
