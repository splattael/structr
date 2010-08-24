require 'helper'

context Structr do
  setup do
    Class.new do
      include Structr
    end
  end

  asserts("module inclusion") { topic.included_modules.include?(Structr) }
  %w(field field_reader field_writer field_accessor converter structr fields).each do |method|
    asserts_topic("to respond to #{method}").respond_to(method)
  end
  asserts("no fields") { topic.fields.empty? }

  asserts("error on no field name") { topic.field }.raises(ArgumentError)
  asserts("error on no regexp") { topic.field(:name) }.raises(ArgumentError)

  context "with field" do
    context "added" do
      setup do
        topic.field :foo, %r{}
        topic.field :bar, %r{}
        topic.field :baz, %r{}
        topic
      end

      asserts("3 added") { topic.fields.size }.equals(3)
    end

    context "defaults" do
      setup do
        topic.field(:no_acc_1, %r{})
        topic.field(:no_acc_2, %r{}, :accessor => false)
      end
      [ :acc_1, :acc_2 ].each do |field|
        asserts("no getter for #{field}") { !topic.respond_to?(field) }
        asserts("no setter for #{field}") { !topic.respond_to?(:"#{field}=") }
      end
    end

    context "accessors" do
      setup do
        topic.field(:acc_1, %r{}, :accessor => true)
        topic.field(:acc_2, %r{}, :accessor => :accessor)
        topic.field_accessor(:acc_3, %r{})
        topic.new
      end

      [ :acc_1, :acc_2, :acc_3 ].each do |method|
        asserts("has getter for #{method}") { topic.respond_to?(method) }
        asserts("has setter for #{method}") { topic.respond_to?(:"#{method}=") }
      end
    end

    context "readers" do
      setup do
        topic.field(:rdr_1, %r{}, :accessor => :reader)
        topic.field_reader(:rdr_2, %r{})
        topic.new
      end

      [ :rdr_1, :rdr_2 ].each do |method|
        asserts("has getter for #{method}") { topic.respond_to?(method) }
        asserts("has no sett for #{method}") { !topic.respond_to?(:"#{method}=") }
      end
    end

    context "writers" do
      setup do
        topic.field(:wrt_1, %r{}, :accessor => :writer)
        topic.field_writer(:wrt_2, %r{})
        topic.new
      end

      [ :wrt_1, :wrt_2 ].each do |method|
        asserts("has no getter for #{method}") { !topic.respond_to?(method) }
        asserts("has setter for #{method}") { topic.respond_to?(:"#{method}=") }
      end
    end
  end # with field

  context "with converter" do
    [ :int, :float, :date, :string ].each do |name|
      asserts("default converter #{name} is a Proc") { topic.converter(name) }.kind_of(Proc)
    end

    [ :unkn, :unkn_reader, :unkn_writer, :unkn_accessor ].each do |field_name|
      asserts("raises NoMethodError for #{field_name}") { topic.send(field_name, %r{}) }.raises(NoMethodError)
    end

    context "default" do
      asserts("int converts to_i") { topic.converter(:int).call("2") }.equals(2)
      asserts("int converts to_f") { topic.converter(:float).call("2") }.equals(2.0)
      asserts("int converts to Date") { topic.converter(:date).call("2009-09-09").to_s }.equals("2009-09-09")
      asserts("int converts to String") { topic.converter(:string).call(2) }.equals("2")
    end

    context "added" do
      setup do
        topic.converter(:proced, proc { |p| p })
        topic.converter(:blocked) { |p| p }
        topic
      end

      asserts("proced converter is a Proc") { topic.converter(:proced) }.kind_of(Proc)
      asserts("blocked converter is a Proc") { topic.converter(:blocked) }.kind_of(Proc)
    end

    context "by-passed" do
      setup do
        pass = proc { |p| p }

        topic.converter :pass, &pass
        topic.field(:block, /(\d+)/) { |p| pass.call(p) }
        topic.field(:param, /(\d+)/, &topic.converter(:pass))
        topic.pass(:mm, /(\d+)/)
        topic.pass(:mm_overwritten, /(\d+)/) { |i| fail("I am overwritten") }
        topic
      end

      asserts("block field passes 1") { topic.fields[0].block.call(1) }.equals(1)
      asserts("param field passes 1") { topic.fields[1].block.call(1) }.equals(1)
      asserts("mm field passes 1") { topic.fields[2].block.call(1) }.equals(1)
      asserts("mm_overwritten field passes 1") { topic.fields[3].block.call(1) }.equals(1)
    end

    context "using method missing" do
      setup do
        topic.int(:no_acc, %r{})
        topic.int_reader(:rdr, %r{})
        topic.int_writer(:wrt, %r{})
        topic.int_accessor(:acc, %r{})
        topic.new
      end

      asserts("no getter for no_acc") { !topic.respond_to?(:no_acc) }
      asserts("no setter for no_acc") { !topic.respond_to?(:no_acc=) }
      asserts("getter for rdr") { topic.respond_to?(:rdr) }
      asserts("no setter for rdr") { !topic.respond_to?(:rdr=) }
      asserts("no getter for wrt") { !topic.respond_to?(:wrt) }
      asserts("setter for wrt") { topic.respond_to?(:wrt=) }
      asserts("getter for acc") { topic.respond_to?(:acc) }
      asserts("setter for acc") { topic.respond_to?(:acc=) }

    end

  end # with converters

  # TODO test structr
  # TODO integration tests

end
