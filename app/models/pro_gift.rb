class ProGift < ApplicationRecord
  belongs_to :from, class_name: 'User', optional: false
  belongs_to :to, class_name: 'User', optional: false
  enum tier: {
    pro: 1,
    patron: 2
  }

  validates :message, length: { maximum: 500 }

  after_create :send_email
  after_create :extend_pro

  def send_email
    ProMailer.gift_email(self).deliver_later
  end

  def extend_pro
    ProRenewalService.new(to).renew_for(Time.now, 1.year.from_now)
  end

  def as_json(*args)
    {
      to: to.name,
      message: message,
      tier: tier
    }.as_json(*args)
  end
end
