class IndexerCommon

  self.add_indexer_initialize_hook do |indexer|
    if AppConfig[:plugins].include?('payments_module')
      add_attribute_to_resolve("authorizer")
      indexer.add_document_prepare_hook {|doc, record|
        if doc['primary_type'] == 'accession' && record['record']['payment_summary']
          summary = record['record']['payment_summary']
          doc['payment_fund_code_u_utext'] = summary['payments'].map {|payment| payment['fund_code']}.compact
          doc['payment_authorizers_u_utext'] = summary['payments'].map {|payment|
            payment['authorizer']['_resolved']['display_name']['sort_name'] rescue nil
          }.compact
          doc['invoice_number_u_utext'] = summary['payments'].map {|payment| payment['invoice_number']}.compact

          payment_dates = summary['payments'].map {|payment| payment['payment_date']}.compact

          doc['payment_date_u_udate'] = payment_dates.map {|date|
            date + 'T00:00:00Z'
          }

          doc["fund_code_enum_s"] = summary['payments'].map{|payment| payment["fund_code"]}.compact

          doc['payment_in_lot_u_ubool'] = summary['in_lot']
        end
      }
    end
  end

end
