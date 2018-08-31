class ProMailer < ApplicationMailer
  def gift_email(gift)
    @gift = gift
    mail(to: gift.to.email, subject: "#{gift.from.name} gifted you a year of Kitsu PRO!")
  end
end
