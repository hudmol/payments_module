class Payment < Sequel::Model(:payment)
  include ASModel
  include Relationships

  corresponds_to JSONModel(:payment)

  set_model_scope :global

  define_relationship(:name => :payment_authorizer,
                      :json_property => 'authorizer',
                      :is_array => false,
                      :contains_references_to_types => proc {
                        AgentManager.registered_agents.map {|a| a[:model]}
                      })
end
