require 'spec_helper'

require 'representable/regexp'

module MyTest
  include Representable::Regexp

  property :name, :regexp => %r{TODO}
end

class Data
end

describe Structr do
  let(:data) { Data.new.extend(MyTest) }

  it 'foo' do
    data
  end

end
