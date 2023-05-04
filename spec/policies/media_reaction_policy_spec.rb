# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediaReactionPolicy do
  subject { described_class.new(user, media_reaction) }

  let(:community_mod) { create(:user, permissions: %i[community_mod]) }
  let(:database_mod) { create(:user, permissions: %i[database_mod]) }
  let(:owner) { create(:user) }
  let(:media_reaction) { build(:media_reaction, user: owner) }

  context 'with visitors' do
    let(:user) { nil }

    it { is_expected.to forbid_actions(%i[create update destroy like]) }
  end

  context 'with other user' do
    let(:user) { token_for create(:user) }

    it { is_expected.to permit_action(:like) }
    it { is_expected.to forbid_actions(%i[create update destroy]) }
  end

  context 'with owner' do
    let(:user) { token_for owner }

    it { is_expected.to permit_actions(%i[create update destroy]) }
    it { is_expected.to forbid_action(:like) }
  end

  context 'with community mod' do
    let(:user) { token_for community_mod }

    it { is_expected.to permit_actions(%i[destroy like]) }
    it { is_expected.to forbid_actions(%i[create update]) }
  end

  context 'with database mod' do
    let(:user) { token_for database_mod }

    it { is_expected.to permit_action(:like) }
    it { is_expected.to forbid_actions(%i[create update destroy]) }
  end
end
