ArchivesSpace::Application.config.after_initialize do
  require_relative 'controllers/payment_accessions_controller'
end
