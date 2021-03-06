class OfflineCheckerJob < ApplicationJob
  queue_as :default

  def perform(user_id, key)
    return if Redis.current.pubsub("CHANNELS", key).any?

    u = AppUser.find_by(id: user_id)
    return if u.blank?
    return if u.offline?

    u&.offline!
  end
end
