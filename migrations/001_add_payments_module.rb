require 'db/migrations/utils'

Sequel.migration do

  up do
    $stderr.puts("Adding Payment Module plugin tables")

    create_table(:payment_summary) do
      primary_key :id

      Integer :lock_version, :default => 0, :null => false
      Integer :json_schema_version, :null => false

      Integer :accession_id

      String :total_price
      DynamicEnum :currency_id
      Integer :in_lot

      apply_mtime_columns
    end

    alter_table(:payment_summary) do
      add_foreign_key([:accession_id], :accession, :key => :id)
    end

    create_table(:payment) do
      primary_key :id

      Integer :lock_version, :default => 0, :null => false
      Integer :json_schema_version, :null => false

      Integer :payment_summary_id

      Date :payment_date
      DynamicEnum :fund_code_id
      String :amount
      String :usd_amount
      String :invoice_number
      TextField :note

      apply_mtime_columns
    end

    alter_table(:payment) do
      add_foreign_key([:payment_summary_id], :payment_summary, :key => :id)
    end

    create_enum("currency_iso_4217", ["AED", "AFN", "ALL", "AMD", "ANG", "AOA",
    "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD",
    "BND", "BOB", "BOV", "BRL", "BSD", "BTN", "BWP", "BYR", "BZD", "CAD", "CDF",
    "CHE", "CHF", "CHW", "CLF", "CLP", "CNY", "COP", "COU", "CRC", "CUC", "CUP",
    "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD",
    "FKP", "GBP", "GEL", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL",
    "HRK", "HTG", "HUF", "IDR", "ILS", "INR", "IQD", "IRR", "ISK", "JMD", "JOD",
    "JPY", "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT", "LAK",
    "LBP", "LKR", "LRD", "LSL", "LTL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK",
    "MNT", "MOP", "MRO", "MUR", "MVR", "MWK", "MXN", "MXV", "MYR", "MZN", "NAD",
    "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR",
    "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG",
    "SEK", "SGD", "SHP", "SLL", "SOS", "SRD", "SSP", "STD", "SVC", "SYP", "SZL",
    "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX",
    "USD", "USN", "UYI", "UYU", "UZS", "VEF", "VND", "VUV", "WST", "XAF", "XAG",
    "XAU", "XBA", "XBB", "XBC", "XBD", "XCD", "XDR", "XOF", "XPD", "XPF", "XPT",
    "XSU", "XTS", "XUA", "XXX", "YER", "ZAR", "ZMW", "ZWL"], "USD")

    create_editable_enum("payment_fund_code", [])



    create_table(:payment_authorizer_rlshp) do
      primary_key :id

      Integer :agent_person_id
      Integer :agent_software_id
      Integer :agent_family_id
      Integer :agent_corporate_entity_id

      Integer :payment_id

      Integer :aspace_relationship_position

      apply_mtime_columns(false)
    end


    alter_table(:payment_authorizer_rlshp) do
      add_foreign_key([:agent_person_id], :agent_person, :key => :id)
      add_foreign_key([:agent_software_id], :agent_software, :key => :id)
      add_foreign_key([:agent_family_id], :agent_family, :key => :id)
      add_foreign_key([:agent_corporate_entity_id], :agent_corporate_entity, :key => :id)
      add_foreign_key([:payment_id], :payment, :key => :id)
    end

  end

end

