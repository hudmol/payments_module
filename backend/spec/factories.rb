require 'factory_girl'

FactoryGirl.define do

  factory :json_payment, class: JSONModel(:payment) do
    payment_date { generate(:yyyy_mm_dd) }
    fund_code { "WING" }
    amount { generate(:number) }
    usd_amount { generate(:number) }
    invoice_number { generate(:number) }
    note { generate(:alphanumstr) }
  end

  factory :json_payment_summary, class: JSONModel(:payment_summary) do
    total_price { generate(:number) }
    currency "USD"
    in_lot true
    payments { rand(10).times.map {|i| build(:json_payment).to_hash} }
  end

end
