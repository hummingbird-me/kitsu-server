class Fixture
  attr_accessor :name, :content

  @@cache = Hash.new { |h, k| h[k] = {} }

  def initialize(name, opts = {})
    @name = name
    @opts = opts
  end

  def to_s
    @opts[:erb] ? compiled : content
  end

  def to_file
    open(filename)
  end

  def filename
    File.realpath(File.join('spec/fixtures/', name), Rails.root)
  end

  private

  def compiled
    @@cache[:compiled][name] ||= ERB.new(content).tap do |erb|
      erb.filename = filename
    end
    @@cache[:compiled][name]
  end

  def content
    @@cache[:content][name] ||= open(filename).read
    @@cache[:content][name]
  end
end

# Helper method for easy, cached access to fixtures.
#
# Included via RSpec config so it takes precedence over Rails 8.1's
# `ActiveRecord::TestFixtures#fixture`, which otherwise shadows this helper.
module FixtureHelper
  def fixture(name, opts = {})
    Fixture.new(name, opts).to_s
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end
