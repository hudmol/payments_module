class Payment < Sequel::Model(:payment)
  include ASModel
  include Relationships

  corresponds_to JSONModel(:payment)

  set_model_scope :global

  define_relationship(:name => :payment_authorizer,
                      :json_property => 'authorizer',
                      :is_array => false,
                      :contains_references_to_types => proc {
                        AgentManager.registered_agents.map {|a| a[:model]}
                      })

  DECIMAL_COLUMNS = ['amount', 'usd_amount']

  def self.create_from_json(json, opts = {})
    super(json, DecimalPaymentColumns.convert_for_save(json, opts, DECIMAL_COLUMNS))
  end


  def update_from_json(json, opts = {}, apply_nested_records = true)
    super(json, DecimalPaymentColumns.convert_for_save(json, opts, DECIMAL_COLUMNS))
  end


  def self.sequel_to_jsonmodel(objs, opts = {})
    jsons = super

    DecimalPaymentColumns.convert_for_jsonmodel(objs, jsons, DECIMAL_COLUMNS)

    jsons
  end

  JSONModel(:payment).add_validation("check_payment_amounts") do |hash|
    DecimalPaymentColumns.errors_for_columns(hash, DECIMAL_COLUMNS)
  end

end
