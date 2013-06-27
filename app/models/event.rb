class Event < ActiveRecord::Base
  serialize :data
  serialize :category
  serialize :unique_args

  # Since we save email downcased, we make sure that all email query data also are downcased.
  scope :email, -> email { email ? where(email: email.downcase) : all }
  scope :named, -> name { name ? where(name: name) : all }
  scope :mailer_action, -> mailer_action { mailer_action ? where(mailer_action: mailer_action) : all }

  def email=(value)
    super(value.to_s.downcase.presence)
  end

  def self.recent(page, per)
    order("happened_at DESC, id DESC").
      page(page).per_page(per)
  end

  def self.oldest_time
    time = minimum(:happened_at)
    time && time.in_time_zone
  end

  def self.newest_time
    time = maximum(:happened_at)
    time && time.in_time_zone
  end

  def self.names
    %w[
      processed dropped delivered deferred bounce
      open click spamreport unsubscribe
    ]
  end

  def self.action_mailers
    %w[
      SellerMailer#contract SellerReportMailer#build
      SingleSellerReportMailer#build
      Online::UnsoldMailer#build Online::UnsoldNotRelistableMailer#build
      Seller::OverdueReminderMailer#build PayoutMailer#build
      BuyerMailer#welcome BuyerMailer#welcome_by_company
      Buyer::PasswordResetMailer#build Employee::PasswordResetMailer#build
      Online::AuctionReminderMailer#build Online::AuctionWonMailer#build
      Online::OutbidMailer#build Hammer::AuctionsWonMailer#build
      SavedSearchMailer#build Buyer::TransportInvoiceMailer#build
      TransportOrder::UnloadedMailer#build TransportOrder::PostedMailer#build
      TransportOrder::ConfirmedMailer#build TransportOrder::CancelledMailer#build
      Buyer::OverdueTransportWarehouseReminderMailer#build
      Buyer::OverdueReminderMailer#build WeaponLicenseConfirmedMailer#build
      PaymentReceiptMailer#build VatExemptionMailer#build
    ].sort
  end

  def smtp_id
    data[:"smtp-id"]
  end
end
