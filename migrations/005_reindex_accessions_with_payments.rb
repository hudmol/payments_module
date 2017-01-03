Sequel.migration do

  up do
    accessions_with_payments = self[:payment_summary].select(:payment_summary__accession_id)

    self[:accession]
      .filter(:id => accessions_with_payments)
      .update(:system_mtime => Time.now)
  end


  down do
    # nothing
  end

end
