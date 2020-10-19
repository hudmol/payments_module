require 'db/migrations/utils'

Sequel.migration do

  up do
    [:agent_person, :agent_corporate_entity, :agent_family, :agent_software].each do |model|
      alter_table(model) do
        add_unique_constraint(:vendor_code, :name => "agent_vendor_code_uniq")
      end
    end
  end

end
