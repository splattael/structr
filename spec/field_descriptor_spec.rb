require 'spec_helper'

describe Structr::FieldDefinition do
  describe 'with single' do
    subject { Structr::FieldDefinition.new(:number, /(\d+)/) }

    it 'defines reader' do
      assert_equal 'number', subject.name
    end

    it 'defines getter' do
      assert_equal :number, subject.getter
    end

    it 'defines setter' do
      assert_equal :number=, subject.setter
    end

    it 'defines ivar' do
      assert_equal :@number, subject.ivar
    end

    it 'has no block' do
      assert_nil subject.block
    end

    it 'does not match' do
      assert_equal [], subject.match('no match')
    end

    it 'matches w/o block' do
      assert_equal %w(23 42), subject.match('23 < 42')
    end

    it 'matches with block' do
      subject.block = proc { |m| m.to_i }
      assert_equal [23, 42], subject.match('23 < 42')
    end
  end

  describe 'multiple' do
    subject { Structr::FieldDefinition.new(:number, /(\d+),(\d+)/) }

    it 'matches w/o block' do
      assert_equal [%w(23 42)], subject.match('costs 23,42$')
    end

    it 'matches with block' do
      subject.block = proc { |dollar, cents| dollar.to_i * 100 + cents.to_i }
      assert_equal [2342], subject.match('costs 23,42$')
    end
  end
end
