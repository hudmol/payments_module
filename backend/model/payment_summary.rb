require_relative 'mixins/payments.rb'

class PaymentSummary < Sequel::Model(:payment_summary)
  include ASModel
  corresponds_to JSONModel(:payment_summary)

  set_model_scope :global

  include Payments
end