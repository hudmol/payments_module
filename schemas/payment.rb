{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "properties" => {
      "payment_date" => {"type" => "date"},
      "fund_code" => {"type" => "string", "dynamic_enum" => "payment_fund_code"},
      "amount" => {"type" => "string"},
      "usd_amount" => {"type" => "string"},
      "invoice_number" => {"type" => "string"},
      "note" => {"type" => "string"},

      "authorizer" => {
        "type" => "object",
        "subtype" => "ref",
        "properties" => {
          "ref" => {"type" => [{"type" => "JSONModel(:agent_corporate_entity) uri"},
                               {"type" => "JSONModel(:agent_family) uri"},
                               {"type" => "JSONModel(:agent_person) uri"},
                               {"type" => "JSONModel(:agent_software) uri"}],
            "ifmissing" => "error"},
          "_resolved" => {
            "type" => "object",
            "readonly" => "true"
          }
        }
      },

      "date_paid" => {"type" => "date"},
      "ok_to_pay" => {"type" => "boolean"},
      "cost_center" => {"type" => "string", "dynamic_enum" => "payments_module_cost_center"},
      "spend_category" => {"type" => "string", "dynamic_enum" => "payments_module_spend_category"},
    }
  }
}
