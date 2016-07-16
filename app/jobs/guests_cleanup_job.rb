class GuestsCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.debug 'start guests cleanup...'
    sleep(5)
    logger.debug 'stop guests cleanup.'
  end
end
