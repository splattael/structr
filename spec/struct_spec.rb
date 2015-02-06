require 'spec_helper'

describe Structr do
  let(:klass) do
    Class.new do
      include Structr
    end
  end

  subject { klass.new }

  it "raises ArgumentError w/o field name" do
    assert_raises ArgumentError do
      klass.field
    end
  end

  it "raise ArgumentError w/o arg" do
    assert_raises ArgumentError do
      klass.field :name
    end
  end

  describe "with field" do
    describe "added" do
      before do
        klass.field :foo, %r{}
        klass.field :bar, %r{}
        klass.field :baz, %r{}
      end

      it "added 3 fields" do
        assert_equal 3, klass.fields.size
      end
    end

    describe "defaults" do
      before do
        klass.field(:no_acc_1, %r{})
        klass.field(:no_acc_2, %r{}, :accessor => false)
      end

      it "has no getters" do
        refute_respond_to subject, :acc_1
        refute_respond_to subject, :acc_2
      end

      it "has no setters" do
        refute_respond_to subject, :acc_1=
        refute_respond_to subject, :acc_2=
      end
    end

    describe "accessors" do
      before do
        klass.field(:acc_1, %r{}, :accessor => true)
        klass.field(:acc_2, %r{}, :accessor => :accessor)
        klass.field_accessor(:acc_3, %r{})
      end

      it "has getters" do
        assert_respond_to subject, :acc_1
        assert_respond_to subject, :acc_2
        assert_respond_to subject, :acc_3
      end

      it "has setters" do
        assert_respond_to subject, :acc_1=
        assert_respond_to subject, :acc_2=
        assert_respond_to subject, :acc_3=
      end
    end

    describe "readers" do
      before do
        klass.field(:rdr_1, %r{}, :accessor => :reader)
        klass.field_reader(:rdr_2, %r{})
      end

      it "has getters" do
        assert_respond_to subject, :rdr_1
        assert_respond_to subject, :rdr_2
      end

      it "has no setters" do
        refute_respond_to subject, :rdr_1=
        refute_respond_to subject, :rdr_2=
      end
    end

    describe "writers" do
      before do
        klass.field(:wrt_1, %r{}, :accessor => :writer)
        klass.field_writer(:wrt_2, %r{})
      end

      it "has no getters" do
        refute_respond_to subject, :wrt_1
        refute_respond_to subject, :wrt_2
      end

      it "has no setters" do
        assert_respond_to subject, :wrt_1=
        assert_respond_to subject, :wrt_2=
      end
    end
  end # with field

  describe "with converter" do
    [ :int, :float, :date, :string ].each do |name|
      it "has default convert for #{name} is a Proc" do
        assert_instance_of Proc, klass.converter(name)
      end
    end

    [ :unkn, :unkn_reader, :unkn_writer, :unkn_accessor ].each do |field_name|
      it "raises NoMethodError for #{field_name}" do
        assert_raises NoMethodError do
          klass.send(field_name, %r{})
        end
      end
    end

    describe "default" do
      it "converts int to to_i" do
        assert_equal 2, klass.converter(:int).call("2")
      end

      it "converts int to to_f" do
        assert_equal 2.0, klass.converter(:float).call("2")
      end

      it "converts int to Date" do
        assert_equal "2009-09-09", klass.converter(:date).call("2009-09-09").to_s
      end
    end

    describe "added" do
      before do
        klass.converter(:proced, proc { |p| p })
        klass.converter(:blocked) { |p| p }
      end

      it "proced converter is a Proc" do
        assert_instance_of Proc, klass.converter(:proced)
      end

      it "blocked converter is a Proc" do
        assert_instance_of Proc, klass.converter(:blocked)
      end
    end

    describe "by-passed" do
      before do
        pass = proc { |p| p }

        klass.converter :pass, &pass
        klass.field(:block, /(\d+)/) { |p| pass.call(p) }
        klass.field(:param, /(\d+)/, &klass.converter(:pass))
        klass.pass(:mm, /(\d+)/)
        klass.pass(:mm_overwritten, /(\d+)/) { |i| fail("I am overwritten") }
      end

      it "block field passes 1" do
        assert_equal 1, klass.fields[0].block.call(1)
      end

      it "param field passes 1" do
        assert_equal 1, klass.fields[1].block.call(1)
      end

      it "mm field passes 1" do
        assert_equal 1, klass.fields[2].block.call(1)
      end

      it "mm_overwritten field passes 1" do
        assert_equal 1, klass.fields[3].block.call(1)
      end
    end

    describe "using method missing" do
      before do
        klass.int(:no_acc, %r{})
        klass.int_reader(:rdr, %r{})
        klass.int_writer(:wrt, %r{})
        klass.int_accessor(:acc, %r{})
      end

      it "no getter for no_acc" do
        refute_respond_to subject, :no_acc
      end

      it "no setter for no_acc" do
        refute_respond_to subject, :no_acc=
      end

      it "getter for rdr" do
        assert_respond_to subject, :rdr
      end

      it "no setter for rdr" do
        refute_respond_to subject, :rdr=
      end

      it "no getter for wrt" do
        refute_respond_to subject, :wrt
      end

      it "setter for wrt" do
        assert_respond_to subject, :wrt=
      end

      it "getter for acc" do
        assert_respond_to subject, :acc
      end

      it "setter for acc" do
        assert_respond_to subject, :acc=
      end
    end

  end # with converters

  # TODO test structr
  # TODO integration tests
end
