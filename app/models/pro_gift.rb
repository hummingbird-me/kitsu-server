class ProGift < ApplicationRecord
  belongs_to :from, class_name: 'User', required: true
  belongs_to :to, class_name: 'User', required: true
  enum length: {
    year: 0,
    month: 1
  }

  validates :message, length: { maximum: 500 }

  after_create :send_email
  after_create :extend_pro

  def send_email
    ProMailer.gift_email(self).deliver_later
  end

  def extend_pro
    ProRenewalService.new(to).renew_for(Time.now, duration.from_now)
  end

  def duration
    case length
    when :year then 1.year
    when :month then 1.month
    else 0
    end
  end

  def as_json(*args)
    {
      to: to.name,
      message: message,
      length: length
    }.as_json(*args)
  end
end
