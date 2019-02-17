module Pro
  class SendGift < Action
    parameter :from, load: User, required: true
    parameter :to, load: User, required: true
    parameter :tier, required: true
    parameter :message

    def call
      ProGift.create!(context)
    end
  end
end
