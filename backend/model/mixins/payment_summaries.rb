module PaymentSummaries

  def self.included(base)
    base.one_to_many :payment_summary

    base.def_nested_record(:the_property => :payment_summaries,
                           :contains_records_of_type => :payment_summary,
                           :corresponding_to_association  => :payment_summary)
  end

end
