require File.dirname(__FILE__) + "/helper.rb"

class TestStructr < Test::Unit::TestCase

  def setup
    @klass = Class.new
    @klass.send(:include, Structr)
    @regexp = %r{}
  end

  def test_module_inclusion
    assert @klass.included_modules.include?(Structr)

    %w(field field_reader field_writer field_accessor
      converter structr fields).each do |method|
      assert @klass.respond_to?(:"#{method}"), "Responds to #{method}"
    end
  end

  def test_fields_addition
    assert @klass.fields.empty?

    @klass.field(:number, @regexp)
    @klass.field(:number, @regexp)
    @klass.field(:white, @regexp)

    assert_equal 3, @klass.fields.size
  end

  def test_field_parameter
    assert_raise(ArgumentError) { @klass.field }
    assert_raise(ArgumentError) { @klass.field(:name) }
  end

  def test_default_field
    @klass.field(:no_acc_1, @regexp)
    @klass.field(:no_acc_2, @regexp, :accessor => false)

    instance = @klass.new
    [ :acc_1, :acc_2 ].each do |acc|
      assert !instance.respond_to?(acc), "Has no getter for #{acc}"
      assert !instance.respond_to?(:"#{acc}="), "Has no setter for #{acc}"
    end
  end

  def test_field_accessor
    @klass.field(:acc_1, @regexp, :accessor => true)
    @klass.field(:acc_2, @regexp, :accessor => :accessor)
    @klass.field_accessor(:acc_3, @regexp)

    instance = @klass.new

    [ :acc_1, :acc_2, :acc_3 ].each do |acc|
      assert instance.respond_to?(acc), "Has getter for #{acc}"
      assert instance.respond_to?(:"#{acc}="), "Has setter for #{acc}"
    end
  end

  def test_field_reader
    @klass.field(:rdr_1, @regexp, :accessor => :reader)
    @klass.field_reader(:rdr_2, @regexp)

    instance = @klass.new

    [ :rdr_1, :rdr_2 ].each do |acc|
      assert instance.respond_to?(acc), "Has getter for #{acc}"
      assert !instance.respond_to?(:"#{acc}="), "Has setter for #{acc}"
    end
  end

  def test_field_writer
    @klass.field(:wrt_1, @regexp, :accessor => :writer)
    @klass.field_writer(:wrt_2, @regexp)

    instance = @klass.new

    [ :wrt_1, :wrt_2 ].each do |acc|
      assert !instance.respond_to?(acc), "Has getter for #{acc}"
      assert instance.respond_to?(:"#{acc}="), "Has setter for #{acc}"
    end
  end

  def test_default_converter
    [ :int, :float, :date, :string ].each do |name|
      converter = @klass.converter(name)
      assert_instance_of Proc, converter, "Has converter for #{name}"
    end
  end

  def test_add_conveter
    assert_nil @klass.converter(:proced)
    assert_nil @klass.converter(:blocked)

    @klass.converter(:proced, proc {|p| p })
    @klass.converter(:blocked) {|p| p }

    assert_instance_of Proc, @klass.converter(:proced)
    assert_instance_of Proc, @klass.converter(:blocked)
  end

  def test_pass_converter
    pass = proc {|p| p }
    @klass.converter :pass, &pass

    @klass.field(:block, /(\d+)/) {|p| pass.call(p) }
    @klass.field(:param, /(\d+)/, &@klass.converter(:pass))
    @klass.pass(:mm, /(\d+)/)
    @klass.pass(:mm_overwritten, /(\d+)/) {|i| fail("I am overwritten") }

    assert "1", @klass.fields[0].block.call("1")
    assert "2", @klass.fields[1].block.call("2")
    assert "3", @klass.fields[2].block.call("3")
    assert "4", @klass.fields[3].block.call("4")
  end

  def test_method_missing_converter_with_accessor
    @klass.int(:no_acc, @regexp)
    @klass.int_reader(:rdr, @regexp)
    @klass.int_writer(:wrt, @regexp)
    @klass.int_accessor(:acc, @regexp)

    instance = @klass.new

    assert !instance.respond_to?(:no_acc)
    assert !instance.respond_to?(:no_acc=)
    assert  instance.respond_to?(:rdr)
    assert !instance.respond_to?(:rdr=)
    assert !instance.respond_to?(:wrt)
    assert  instance.respond_to?(:wrt=)
    assert  instance.respond_to?(:acc)
    assert  instance.respond_to?(:acc=)
  end

  def test_method_missing_with_invalid_converter
    [ :unkn, :unkn_reader, :unkn_writer, :unkn_accessor ].each do |field_name| 
      assert_raise(NoMethodError) do
        @klass.send(field_name, @regexp)
      end
    end
  end

  # TODO test structr
  # TODO integration tests

end
