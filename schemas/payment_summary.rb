{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "properties" => {
      "total_price" => {"type" => "string"},
      "currency" => {"type" => "string", "dynamic_enum" => "currency_iso_4217"},
      "spend_category" => {"type" => "string", "dynamic_enum" => "payments_module_spend_category"},
      "in_lot" => {"type" => "boolean"},
      "payments" => {"type" => "array", "items" => {"type" => "JSONModel(:payment) object"}},
    },
  },
}
