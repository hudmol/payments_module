require 'db/migrations/utils'

Sequel.migration do

  up do
    create_editable_enum('payments_module_cost_center',
                         [
                          'CC0681',
                          'CC0682',
                          'CC0683',
                          'CC0684',
                          'CC0685',
                          'CC0686',
                          'CC0687',
                          'CC0688',
                         ])

    create_editable_enum('payments_module_spend_category',
                         [
                          'SC121',
                          'SC120',
                          'SC122',
                          'SC670',
                          'SC118',
                          'SC669',
                          'SC119',
                         ])

    alter_table(:payment) do
      add_column(:date_paid, Date, :null => true)
      add_column(:ok_to_pay, Integer, :default => 0)

      add_column(:cost_center_id, Integer, :null => true)
      add_foreign_key([:cost_center_id], :enumeration_value, :key => :id, :name => 'payments_module_cost_center_fk')

      add_column(:spend_category_id, Integer, :null => true)
      add_foreign_key([:spend_category_id], :enumeration_value, :key => :id, :name => 'payments_module_spend_category_fk')
    end
  end

end

