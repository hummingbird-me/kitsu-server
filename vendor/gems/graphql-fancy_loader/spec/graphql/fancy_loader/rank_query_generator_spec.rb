# frozen_string_literal: true

RSpec.describe GraphQL::FancyLoader::RankQueryGenerator do
  subject { described_class.new(column: column, partition_by: partition_by, table: table) }

  let(:column) { :email }
  let(:partition_by) { :user_id }
  let(:table) { Post.arel_table }

  describe '#arel' do
    let(:raw_sql) { 'ROW_NUMBER() OVER (PARTITION BY "posts"."user_id" ORDER BY "posts"."email" ASC) AS email_rank' }

    it 'should return a window function for a RankedModel column' do
      expect(subject.arel).to be_a(Arel::Nodes::As)
      expect(subject.arel.to_sql).to eq(raw_sql)
    end
  end
end
