require 'rails_helper'

RSpec.describe InstallmentPolicy do
  let(:angel) { build(:user, sfw_filter: true) }
  let(:pervert) { build(:user, sfw_filter: false) }
  let(:sfw_installment) { build(:installment, media: build(:anime)) }
  let(:nsfw_installment) { build(:installment, media: build(:anime, :nsfw)) }
  subject { described_class }

  permissions :show? do
    context 'for sfw content' do
      it('should allow anons') { should permit(nil, sfw_installment) }
      it('should allow kids') { should permit(angel, sfw_installment) }
      it('should allow perverts') { should permit(pervert, sfw_installment) }
    end
    context 'for nsfw content' do
      it('should not allow anons') { should_not permit(nil, nsfw_installment) }
      it('should not allow kids') { should_not permit(angel, nsfw_installment) }
      it('should allow perverts') { should permit(pervert, nsfw_installment) }
    end
  end
end
