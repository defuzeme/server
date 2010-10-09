class Array
  def to_select
    inject([]) do |out, elem|
      out << [elem, out.size]
      out
    end
  end
end

module ActiveRecord
  class Base
    # Get list of mandatory fields from presence validations
    def self.mandatory_fields
      self.validators.select {|v| v.kind == :presence }.map(&:attributes).flatten
    end
  end
end
