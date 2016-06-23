module Ravelin
  class Label < RavelinObject
    attr_accessor :customer_id,
      :label,
      :comment,
      :reviewer

    attr_required :customer_id,
      :label,
      :comment

    LABEL_VALUES = %w(UNREVIEWED GENUINE FRAUDSTER)

    def validate
      super

      raise InvalidLabelValueError.new("Label value be one of #{LABEL_VALUES.join(', ')}") unless LABEL_VALUES.include?(label)
    end
  end
end
