require 'db/migrations/utils'

Sequel.migration do

  up do
    [:agent_person, :agent_corporate_entity, :agent_family, :agent_software].each do |model|
      alter_table(model) do
        add_column(:vendor_code, String, :null => true)
      end
    end
  end

end

