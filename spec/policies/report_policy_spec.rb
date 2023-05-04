# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportPolicy do
  subject { described_class.new(user, report) }

  let(:reporter) { create(:user) }
  let(:report) { build(:report, user: reporter) }

  context 'with reporter' do
    let(:user) { token_for reporter }

    it { is_expected.to permit_actions(%i[create update]) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'with visitors' do
    let(:user) { nil }

    it { is_expected.to forbid_actions(%i[create update destroy]) }
  end

  context 'with other user' do
    let(:other) { create(:user) }
    let(:user) { token_for other }

    it { is_expected.to forbid_actions(%i[update destroy]) }
  end

  context 'with database mod' do
    let(:database_mod) { create(:user, permissions: %i[database_mod]) }
    let(:user) { token_for database_mod }

    it { is_expected.to forbid_actions(%i[update destroy]) }
  end

  context 'with community mod' do
    let(:community_mod) { create(:user, permissions: %i[community_mod]) }
    let(:user) { token_for community_mod }

    it { is_expected.to permit_action(:update) }
    it { is_expected.to forbid_actions(%i[create destroy]) }
  end
end
