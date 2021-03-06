
class Torrent < ActiveRecord::Base

  # notification concern

  private

    def translate_and_deliver(subject_key, body_key, body_args = {})
      s = I18n.t(subject_key)
      b = I18n.t(body_key, body_args)
      self.user.deliver_notification s, b
    end

    def notify_inactivation(inactivator, reason)
      translate_and_deliver('m.torrent.notify_inactivation.subject',
                            'm.torrent.notify_inactivation.body',
                            :name => self.name, :inactivator_id => inactivator.id, :inactivator => inactivator.username, :reason => reason)
    end

    def notify_activation(activator)
      translate_and_deliver('m.torrent.notify_activation.subject',
                            'm.torrent.notify_activation.body',
                            :id => self.id, :name => self.name, :activator_id => activator.id, :activator => activator.username)
    end

    def notify_destruction(destroyer, reason)
      translate_and_deliver('m.torrent.notify_destruction.subject',
                            'm.torrent.notify_destruction.body',
                            :name => self.name, :destroyer_id => destroyer.id, :destroyer => destroyer.username, :reason => reason)
    end

    def notify_reseed_request(user, requester)
      return if user == requester
      user.deliver_notification I18n.t('m.torrent.request_reseed.notification_subject'),
                                I18n.t('m.torrent.request_reseed.notification_body',
                                :id => self.id, :name => self.name, :requester_id => requester.id, :requester => requester.username)
    end
end