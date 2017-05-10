require 'db/migrations/utils'

Sequel.migration do

  up do
    invalid_values = []

    columns = {:payment_summary => [:total_price],
               :payment => [:amount, :usd_amount]}

    columns.keys.each do |table|
      columns.fetch(table).each do |column|
        self[table].select(:id, column).each do |row|
          id = row[:id]
          value = row[column]

          unless value =~ /\A[0-9]+\z/ || value =~ /\A[0-9]+\.[0-9]{1,2}\z/
            invalid_values << {:table => table, :column => column, :id => id, :value => value}
          end
        end
      end
    end

    unless invalid_values.empty?
      puts ""
      puts "=" * 72

      puts "The following invalid currency amounts were identified.  You will need to manually fix these in your database before the migration can complete."
      puts ""
      puts "Valid numbers are either whole numbers (like '1000'), or numbers with two decimal places ('1000.50')"
      puts ""

      invalid_values.each do |value|
        puts value.inspect
      end

      puts "=" * 72
      puts ""

      raise "Abort migration"
    end

    alter_table(:payment_summary) do
      set_column_type :total_price, 'DECIMAL(16, 2)'
    end

    alter_table(:payment) do
      set_column_type :amount, 'DECIMAL(16, 2)'
      set_column_type :usd_amount, 'DECIMAL(16, 2)'
    end
  end

end

