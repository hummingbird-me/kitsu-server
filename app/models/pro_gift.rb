class ProGift < ApplicationRecord
  belongs_to :from, class_name: 'User', required: true
  belongs_to :to, class_name: 'User', required: true

  validates :message, length: { maximum: 500 }

  after_create :send_email
  after_create :extend_pro

  def send_email
    ProMailer.gift_email(self).deliver_later
  end

  def extend_pro
    ProRenewalService.new(to).renew_for(Time.now, 1.year.from_now)
  end
end
