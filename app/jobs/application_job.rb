class ApplicationJob < ActiveJob::Base

  self.logger = Sidekiq::Logging.logger
end
