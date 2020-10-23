require 'db/migrations/utils'
require 'csv'

def load_tsv_into_enumeration(db, enumeration_name, prompt)
  loop do
    begin
      $stderr.puts ""
      $stderr.puts prompt
      $stderr.flush
      file = $stdin.readline.to_s.strip

      break if file.empty?

      codes = []
      CSV.foreach(file, :col_sep => "\t") do |row|
        code = row.map {|s| s.to_s.strip}.first

        # Empty line
        next if code.nil?

        codes << code
      end

      enum_id = self[:enumeration][:name => enumeration_name][:id]

      raise "Couldn't find an enumeration with name: #{enumeration_name}" unless enum_id

      codes.each_with_index do |code, i|
        self[:enumeration_value].insert(:enumeration_id => enum_id,
                                        :value => code,
                                        :position => i,
                                        :readonly => 0)
      end

      # Success!
      return
    rescue
      $stderr.puts "File '#{file}' doesn't exist or couldn't be opened: #{$!}"
      sleep 1
    end
  end
end

Sequel.migration do

  up do
    create_editable_enum('payments_module_cost_center', [])
    create_editable_enum('payments_module_spend_category', [])

    alter_table(:payment) do
      add_column(:date_paid, Date, :null => true)
      add_column(:ok_to_pay, Integer, :default => 0)

      add_column(:cost_center_id, Integer, :null => true)
      add_foreign_key([:cost_center_id], :enumeration_value, :key => :id, :name => 'payments_module_cost_center_fk')

      add_column(:spend_category_id, Integer, :null => true)
      add_foreign_key([:spend_category_id], :enumeration_value, :key => :id, :name => 'payments_module_spend_category_fk')
    end

    if !defined?(ASpaceEnvironment) || ASpaceEnvironment.environment == :production
      $stderr.puts <<EOF

You seem to be setting up the ArchivesSpace payment module for the first time.

At this point, you can pre-load the system with a set of cost centers and spend
categories if you have them ready.  You can always add and edit more values
later.

EOF

      self.transaction do
        load_tsv_into_enumeration(self,
                                  'payments_module_cost_center',
                                  'Please provide a text file containing one cost center code per line (leave blank to skip): ')

        load_tsv_into_enumeration(self,
                                  'payments_module_spend_category',
                                  'Please provide a text file containing one spend category code per line (leave blank to skip): ')
      end
    end
  end
end

