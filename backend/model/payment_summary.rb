require_relative 'mixins/payments.rb'

class PaymentSummary < Sequel::Model(:payment_summary)
  include ASModel
  corresponds_to JSONModel(:payment_summary)

  set_model_scope :global

  include Payments

  DECIMAL_COLUMNS = ['total_price']

  def self.create_from_json(json, opts = {})
    super(json, DecimalPaymentColumns.convert_for_save(json, opts, DECIMAL_COLUMNS))
  end


  def update_from_json(json, opts = {}, apply_nested_records = true)
    super(json, DecimalPaymentColumns.convert_for_save(json, opts, DECIMAL_COLUMNS))
  end


  def self.update_toplevel_mtimes(*)
    # Just here as a bugfix for versions 2.0.0 -- 2.0.1.
  end

  def self.sequel_to_jsonmodel(objs, opts = {})
    jsons = super

    DecimalPaymentColumns.convert_for_jsonmodel(objs, jsons, DECIMAL_COLUMNS)

    jsons
  end

  JSONModel(:payment_summary).add_validation("check_payment_summary_amounts") do |hash|
    DecimalPaymentColumns.errors_for_columns(hash, DECIMAL_COLUMNS)
  end

end
