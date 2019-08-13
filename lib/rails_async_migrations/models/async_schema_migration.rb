class AsyncSchemaMigration < ActiveRecord::Base
  validates :version, presence: true
  validates :state, inclusion: { in: %w[created pending processing done failed] }
  validates :direction, inclusion: { in: %w[up down] }

  after_save :trace

  scope :created, -> { where(state: 'created').by_version }
  scope :pending, -> { where(state: 'pending').by_version }
  scope :processing, -> { where(state: 'processing').by_version }
  scope :done, -> { where(state: 'done').by_version }
  scope :failed, -> { where(state: 'failed').by_version }
  scope :by_version, -> { order(version: :asc) }

  def trace
    RailsAsyncMigrations::Tracer.new.verbose "Asynchronous migration `#{id}` is now `#{state}`"
  end

  #
  # Determines the next migration to be run. This allows us to
  # retry failed migrations.
  #
  # @return [AsyncSchemaMigration] The next AsyncSchemaMigration to run
  #
  def self.next_migration
    self.where(state: ['created', 'failed']).order('created_at ASC').first
  end
end
