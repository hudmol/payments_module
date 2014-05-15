module PaymentFindOpts
  def find_opts
    opts = super

    opts.merge('resolve[]' => opts.fetch('resolve[]', []) + ['authorizer'])
  end
end


AccessionsController.class_eval do
  include PaymentFindOpts
end
