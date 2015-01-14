require_relative '02_searchable'
require 'active_support/inflector'

module TableizeFix
  def tableize
    return 'humans' if self.downcase == 'human'
    super
  end
end

class String
  prepend TableizeFix
end

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.to_s.constantize
  end

  def table_name
    class_name.to_s.tableize
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {class_name: name.to_s.capitalize,
                foreign_key: "#{name.to_s}_id".to_sym,
                primary_key: :id}
    defaults.merge(options).each do |k, v|
      self.send((k.to_s + '='), v)
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {class_name: name.to_s.singularize.capitalize,
                foreign_key: "#{self_class_name.to_s.singularize.downcase}_id".to_sym,
                primary_key: :id}
    defaults.merge(options).each do |k, v|
      self.send((k.to_s + '='), v)
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    blt = BelongsToOptions.new(name, options)
    @assoc ||= {}
    @assoc[name] = blt
    define_method(name) do
      blt.model_class
      .where(blt.primary_key => self.send(blt.foreign_key))
      .first
    end
  end

  def has_many(name, options = {})
    define_method(name) do
      hmy = HasManyOptions.new(name, self.class.name, options)
      hmy.model_class
      .where(hmy.foreign_key => self.send(hmy.primary_key))
    end
  end

  def assoc_options
    @assoc ||= {}
  end
end

class SQLObject
  extend Associatable
end
