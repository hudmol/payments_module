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
    },
  },
}