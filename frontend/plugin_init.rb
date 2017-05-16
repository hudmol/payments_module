ArchivesSpace::Application.config.after_initialize do
  require_relative 'lib/currency_formatter'
  require_relative 'controllers/payment_accessions_controller'
end
