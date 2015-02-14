class SubTask < ActiveRecord::Base
  default_scope -> { order(:id) }

  belongs_to :task

  validates :name, presence: true

  after_update :publish_to_redis

  private

  def publish_to_redis
    $redis.publish "sockjs-demo:yata:subtask", { id: id, done: done? }.to_json
  end
end
