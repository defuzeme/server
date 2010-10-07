module Defuzeme
  module Enum
    def enum field, values, options = {}
      puts "enum defined #{self.name}##{field} #{values.inspect}"
      # set key constant
      constant_name = "#{field.to_s.upcase}_KEYS"
      puts "constant name: #{constant_name}"
      const_set(constant_name, values)
      # add validation
      validates_numericality_of field, {
        :only_integer => true,
        :greater_than_or_equal_to => 0,
        :less_than => values.size,
        :allow_blank => true
      }.merge(options)
    end
  end
end
