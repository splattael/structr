require 'helper'

include Structr

context Struct::FieldDefinition do
  context "with single" do
    setup { FieldDefinition.new(:number, /(\d+)/) }

    asserts("name") { topic.name }.equals("number")
    asserts("getter") { topic.getter }.equals(:number)
    asserts("setter") { topic.setter }.equals(:number=)
    asserts("ivar") { topic.ivar }.equals(:@number)
    asserts("no block") { topic.block }.nil
    asserts("no match") { topic.match("no match") }.equals([])
    asserts("match without block") { topic.match("23 < 42") }.equals(["23", "42"])
    asserts("match with block") do
      topic.block = proc { |m| m.to_i }
      topic.match("23 < 42")
    end.equals([23, 42])
  end

  context "multiple" do
    setup { FieldDefinition.new(:number, /(\d+),(\d+)/) }

    asserts("match without block") { topic.match("costs 23,42$") }.equals([["23", "42"]])
    asserts("matech with block") do
      topic.block = proc { |dollar, cents| dollar.to_i * 100 + cents.to_i }
      topic.match("costs 23,42$")
    end.equals([2342])
  end
end
