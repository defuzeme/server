module Defuzeme
  # This module in used to create symbol enumeration in models, stored as integer
  # Here is an example (assuming your Model have an integer called 'brand')
  #
  # ----------------
  # Model definition
  # ----------------
  #
  # class Car < ActiveRecord::Base
  #   extend Defuzeme::Enum
  #
  #   enum :brand, [:bmw, :audi, :porche, :lamborgini]
  # end
  # 
  # --------------
  # Model use case
  # --------------
  # 
  # > m = Car.create
  # > m.brand_key = 'bmw'
  # > m.save; m.reload
  # > m.brand_key
  # :bmw
  # > m.brand
  # 0
  #
  # > m.brand = 2
  # > m.save; m.reload
  # > m.brand_key
  # :porche
  #
  # > m.brand = 7
  # > m.save
  # false
  #
  # > m.brand_key = :toto
  # > m.save
  # false
  #
  # --------------------
  # forms & translations
  # --------------------
  # 
  # Translation are fetched from:
  # :en, :activerecord, :attributes, [model_name], [plural_enum_name], [key]
  # 
  # So here we can have:
  # en:
  #   activerecord:
  #     attributes:
  #       car:
  #         brands:
  #           bmw: BMW
  #           audi: Audi
  #           porche: Porche
  #           lamborgini: Lamborgini
  # 
  # > Car.brands
  # ['BMW', 'Audi', 'Porche', 'Lamborgini']
  #
  # to_select make this array understandable for rails helpers
  #
  # > Car.brands.to_select
  # [['BMW', 0], ['Audi', 1], ['Porche', 2], ['Lamborgini', 3]]
  #
  module Enum

    # Default usage:
    #
    # enum :brand, [:bmw, :audi, :porche, :lamborgini]
    #
    # You can pass optional arguments to the validation method:
    #
    # enum :price, [:cheap, :expensive], :allow_blank => false
    def enum field, values, options = {}
      # set key constant
      constant_name = "#{field.to_s.upcase}_KEYS"
      const_set(constant_name, values.map(&:to_sym))

      # add validation
      validates_numericality_of field, {
        :only_integer => true,
        :greater_than_or_equal_to => 0,
        :less_than => values.size,
        :allow_blank => true
      }.merge(options)

      # define class accessors
      module_eval "
        def self.#{field.to_s.pluralize}
          #{constant_name}.map do |value|
            I18n.t value, :scope => [:activerecord, :attributes, :#{name.underscore}, :#{field.to_s.pluralize}], :default => value
          end
        end

        def self.#{field}_key i
          #{constant_name}[i] if i.is_a? Integer
        end

        def self.#{field}_index key
          #{constant_name}.index(key)
        end
      "

      # define instance accessors
      module_eval "
        def #{field}_key
          self.class.#{field}_key #{field}
        end

        def #{field}_key= key
          self.#{field} = self.class.#{field}_index key.to_sym
        end
      "
    end
  end
end
