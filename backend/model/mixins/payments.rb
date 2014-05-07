module Payments

  def self.included(base)
    base.one_to_many :payment

    base.def_nested_record(:the_property => :payments,
                           :contains_records_of_type => :payment,
                           :corresponding_to_association  => :payment)
  end

end
