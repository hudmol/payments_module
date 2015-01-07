Sequel.migration do

  up do
    alter_table(:payment_authorizer_rlshp) do
      add_column(:suppressed, :integer, :null => false, :default => 0)
    end
  end


  down do
    # nothing
  end

end
