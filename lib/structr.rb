require 'date'

module Structr

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    Converter = {
      :int    =>  proc { |m| m.to_i },
      :float  =>  proc { |m| m.to_f },
      :date   =>  proc { |m| ::Date.parse(m) },
      :string =>  proc { |m| m.to_s },
    }

    def field(name, regexp, options={}, &block)
      fields << FieldDefinition.new(name, regexp, &block)

      case options[:accessor]
      when :reader
        attr_reader(name)
      when :writer
        attr_writer(name)
      when :accessor, true
        attr_accessor(name)
      end
    end

    def field_accessor(name, regexp, &block)
      field(name, regexp, :accessor => true, &block)
    end

    def field_reader(name, regexp, &block)
      field(name, regexp, :accessor => :reader, &block)
    end

    def field_writer(name, regexp, &block)
      field(name, regexp, :accessor => :writer, &block)
    end

    def fields
      @fields ||= []
    end

    def structr(content, *options)
      instance = new(*options)
      fields.each do |field|
        value = field.match(content)
        value = value.first if value.size < 2
        if instance.respond_to?(field.setter)
          instance.send(field.setter, value)
        else
          instance.instance_variable_set(field.ivar, value)
        end
      end
      instance
    end

    def converter(name, proc=nil, &block)
      if block = proc || block
        Converter[name] = block
      else
        Converter[name]
      end
    end

    def method_missing(method, *args, &block)
      name = method.to_s.gsub(/_(accessor|reader|writer)/, '')
      if converter = converter(name.to_sym)
        field(args[0], args[1], :accessor => $1 ? $1.to_sym : nil, &converter)
      else
        super(method, *args, &block)
      end
    end

  end

  class FieldDefinition

    attr_accessor :name, :block

    def initialize(name, regexp, &block)
      @name, @regexp, @block = name.to_s, regexp, block
    end

    def setter
      :"#{name}="
    end

    def getter
      :"#{name}"
    end

    def ivar
      :"@#{name}"
    end

    def match(string)
      string.scan(@regexp).map do |matched|
        matched = matched.first  if matched.size == 1
        if @block
          @block.call(*matched)
        else
          matched
        end
      end
    end

  end

end
