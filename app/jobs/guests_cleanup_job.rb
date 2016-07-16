class GuestsCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.info 'start guests cleanup...'
    sleep(5)
    logger.info 'stop guests cleanup.'
  end
end
