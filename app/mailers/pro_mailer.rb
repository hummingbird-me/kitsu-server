class ProMailer < ApplicationMailer
  def gift_email(gift)
    @gift = gift

    mail(
      to: gift.to.email,
      subject: default_i18n_subject(name: gift.user.name, tier: gift.tier.titleize)
    )
  end

  def cancellation_email(user, tier, reason = nil)
    @user = user
    @tier = tier
    @reason = reason

    mail(
      to: user.email,
      subject: default_i18n_subject(tier: tier.titleize)
    )
  end

  def welcome_email(subscription)
    @subscription = subscription

    mail(
      to: subscription.user.email,
      subject: default_i18n_subject(tier: subscription.tier.titleize)
    )
  end

  def billing_issue_email(subscription)
    @subscription = subscription

    mail(
      to: subscription.user.email
    )
  end
end
