require File.dirname(__FILE__) + "/helper.rb"

class TestFieldDescriptor < Test::Unit::TestCase

  include Structr

  def setup
    @single = FieldDefinition.new(:number, /(\d+)/)
    @multiple = FieldDefinition.new(:number, /(\d+),(\d+)/)
  end

  def test_number_accessors
    assert_equal "number", @single.name
    assert_equal :number, @single.getter
    assert_equal :number=, @single.setter
    assert_equal :@number, @single.ivar
    assert_nil @single.block
  end

  def test_no_match
    string = "no match"

    matched = @single.match(string)
    assert_equal [], matched
  end

  def test_single_match_without_block
    string = "23 is lower than 42"

    matched = @single.match(string)
    assert_equal ["23", "42"], matched
  end

  def test_single_match_with_block
    string = "23 is lower than 42"
    @single.block = proc {|m| m.to_i }

    matched = @single.match(string)
    assert_equal [23, 42], matched
  end

  def test_multiple_match_without_block
    string = "costs 23,42$"

    matched = @multiple.match(string)
    assert_equal [["23", "42"]], matched
  end

  def test_multiple_match_with_block
    string = "costs 23,42$"
    @multiple.block = proc {|(dollar, cents)| dollar.to_i * 100 + cents.to_i }

    matched = @multiple.match(string)
    assert_equal [2342], matched
  end

end
