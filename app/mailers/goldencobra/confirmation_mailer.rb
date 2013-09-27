module Goldencobra
  class ConfirmationMailer < ActionMailer::Base
    default from: 'do-not-reply@goldencobra.de'
    default subject: ''
    default content_type: 'text/plain'

    def send_confirmation_mail(email = nil)
      if email
        mail to: email, subject: 'Herzlich Willkommen bei Goldencobra.de'
      else
        do_not_deliver!
      end
    end

    def send_support_mail(link)
      @link = link
      mail to: Goldencobra::Setting.for_key("goldencobra.live-support.email"), :subject => "Live Support Anfrage von: #{Goldencobra::Setting.for_key("goldencobra.url")}"
    end

  end

  # http://stackoverflow.com/questions/6550809/rails-3-how-to-abort-delivery-method-in-actionmailer

  module ActionMailer
    class Base
      # A simple way to short circuit the delivery of an email from within
      # deliver_* methods defined in ActionMailer::Base subclases.
      def do_not_deliver!
        raise AbortDeliveryError
      end

      def process(*args)
        begin
          super *args
        rescue AbortDeliveryError
          self.message = BlackholeMailMessage
        end
      end
    end
  end

  class AbortDeliveryError < StandardError
  end

  class BlackholeMailMessage < Mail::Message
    def self.deliver
      false
    end
  end
end