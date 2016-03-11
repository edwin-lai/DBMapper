class AssociationOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key,
    :opts
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end
