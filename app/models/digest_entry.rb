# frozen_string_literal: true

# One notification event, waiting for its delivery window to close.
class DigestEntry < ApplicationRecord
  belongs_to :recipient, class_name: "User"

  scope :unread, -> { where(read_at: nil) }
  scope :for_window, ->(window) { where(delivery_window: window) }

  # Entries older than two windows are never going to be delivered. The rollup
  # job leaves them behind rather than deleting them inline, so that a slow
  # window does not turn into a slow DELETE against the primary.
  scope :stale, -> { where(created_at: ...2.days.ago) }

  def collapse_key
    [repository_id, subject_type, subject_id].join(":")
  end
end
