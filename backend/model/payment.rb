class Payment < Sequel::Model(:payment)
  include ASModel
  corresponds_to JSONModel(:payment)

  set_model_scope :global
end