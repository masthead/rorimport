class SidekiqUtil

  def self.queues
    ::Sidekiq::Stats.new.queues.keys.map { |name| ::Sidekiq::Queue.new(name) }
  end

  def self.clear_all
    SidekiqUtil.queues.each { |q| q.clear }
  end

  def self.reset_failed
    Sidekiq.redis {|c| c.del('stat:failed') }
  end

  def self.reset_stats
    Sidekiq::Stats.new.reset
  end

end