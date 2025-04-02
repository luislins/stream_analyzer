require 'rufus-scheduler'

Rails.logger.info "Starting Rufus Scheduler..."

scheduler = Rufus::Scheduler.singleton

scheduler.every '1m' do
  Rails.logger.info "Scheduler triggered UpdateStreamersJob at #{Time.current}"
  UpdateStreamersJob.perform_later
end

Rails.logger.info "Rufus Scheduler started successfully" 