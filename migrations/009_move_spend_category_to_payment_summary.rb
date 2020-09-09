require 'db/migrations/utils'

Sequel.migration do

  up do
    alter_table(:payment) do
      drop_constraint(:payments_module_spend_category_fk, :type => :foreign_key)
      drop_column(:spend_category_id)
    end

    alter_table(:payment_summary) do
      add_column(:spend_category_id, Integer, :null => true)
      add_foreign_key([:spend_category_id], :enumeration_value, :key => :id, :name => 'payments_module_spend_category_fk')
    end
  end

end

