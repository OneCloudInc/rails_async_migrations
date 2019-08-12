# we check the state of the queue and launch run worker if needed
module RailsAsyncMigrations
  class Workers
    module Resque
      class FireMigrationWorker
        @queue = :migrations

        def self.perform(migration_id)
          Migration::FireMigration.new(
            migration_id
          ).perform
        end
      end
    end
  end
end
