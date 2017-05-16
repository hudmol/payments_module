class CurrencyFormatter

  class Implementation
    extend ActionView::Helpers::NumberHelper
  end

  def self.number_to_currency(amount)
    # Format without a $
    Implementation.number_to_currency(amount, :unit => '')
  end

end
