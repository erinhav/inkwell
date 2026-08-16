# frozen_string_literal: true

class DigestMailer < ApplicationMailer
  def daily(recipient, entries)
    @recipient = recipient
    @groups = entries.group_by(&:repository_id)

    mail(
      to: recipient.notification_email,
      subject: "Your daily digest (#{entries.size} updates)"
    )
  end
end
