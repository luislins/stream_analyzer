require 'rufus-scheduler'

Rails.logger.info "Starting Rufus Scheduler..."

scheduler = Rufus::Scheduler.singleton

# Atualiza os dados dos streamers a cada 5 minutos
scheduler.every '5m' do
  Rails.logger.info "Scheduler triggered UpdateStreamersJob at #{Time.current}"
  UpdateStreamersJob.perform_later
end

Rails.logger.info "Rufus Scheduler started successfully" 