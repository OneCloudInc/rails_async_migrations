# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  class Workers
    module Resque
      class CheckQueueWorker
        @queue = :migrations

        def perform
          Migration::CheckQueue.new.perform
        end
      end
    end
  end
end
