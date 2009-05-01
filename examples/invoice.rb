require 'structr'

LineItem = Struct.new(:number, :description, :price)

class Invoice
  include Structr

  converter :line_item do |*matched|
    LineItem.new(*matched)
  end

  int_accessor    :number,      /#(\d+)/
  field_accessor  :address,     /Address:\n(.*?)\n(.*?)\n(.*?)\n/
  date_accessor   :date,        /on (\d+-\d+-\d+)/
  line_item       :line_items,  /^(\d+)\.\s+(.*?)\s+(\d+,\d+)$/

  def items
    Array(@line_items)
  end
end

string = (STDIN.tty? ? DATA : STDIN).readlines.join

invoice = Invoice.structr(string)
p invoice
p invoice.items
p invoice.number

__END__
This is #23             on 2009-04-30

Address:
Evergreen Street 23
12345 Malrose
Nirvana

1. Root server  23,42
2. Domain       45,00
3. Another      32,00

# TODO
 * Subtypes? LineItem
