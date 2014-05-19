require_relative '../../../../backend/spec/spec_helper'
require_relative 'factories'

describe "Payments module" do

  let (:original_summary) { build(:json_payment_summary).to_hash }

  before(:all) do
    enum_id = Enumeration[:name => "payment_fund_code"].id

    unless EnumerationValue[:enumeration_id => enum_id,
                            :value => "TEST"]
      EnumerationValue.create(:enumeration_id => enum_id,
                              :value => "TEST",
                              :readonly => 0)
    end
  end

  it "supports creating an accession with some payments" do
    acc = create_accession(:payment_summaries => [original_summary])

    summary = Accession.to_jsonmodel(acc.id)['payment_summaries'].first

    summary['total_price'].should eq(original_summary['total_price'])

    summary['payments'].each_with_index do |payment, i|
      ['payment_date', 'fund_code', 'amount', 'usd_amount'].each do |prop|
        payment[prop].should eq(original_summary['payments'][i][prop])
      end
    end
  end


  it "can store the authorizer agent on a payment" do
    authorizer = create(:json_agent_person)

    payment = build(:json_payment)
    payment['authorizer'] = {'ref' => authorizer.uri}

    original_summary['payments'] = [payment]

    acc = create_accession(:payment_summaries => [original_summary])

    summary = Accession.to_jsonmodel(acc.id)['payment_summaries'].first
    payment = summary['payments'].first

    payment['authorizer']['ref'].should eq(authorizer.uri)
  end

end
