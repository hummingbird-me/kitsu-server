# frozen_string_literal: true

class IPFilter < ApplicationRecord
  self.inheritance_column = nil
  enum :type, {
    asn: 1,
    city: 2,
    country: 3
  }
  flag :actions, %i[
    require_email_validation
    block_posting
  ]

  scope :by_asn, ->(asn) { where(type: :asn, pattern: asn) }
  scope :by_city, ->(city) { where(type: :city, pattern: city) }
  scope :by_country, ->(country) { where(type: :country, pattern: country) }

  def self.take_action?(actions)
    where_actions(actions).limit(1).present?
  end

  def self.applicable_actions
    # HACK: Make ourselves an ActiveFlag::Value object without a model instance
    IPFilter.actions.to_value(nil, pluck(:actions).reduce(0, :|))
  end

  def self.by_ip(ip)
    asn = IPASN.matching_ip(ip).select(:autonomous_system_number)
    geoname = IPCity.matching_ip(ip).joins(:geoname)
    # All of this allows us to do a single query to get all the actions for an IP without making
    # multiple queries to the database. This COULD be done directly in AR without using Arel, but
    # the autonomous_system_number and geoname_id columns are integers and the pattern is a string,
    # and ActiveRecord doesn't understand it needs to add casts.
    asn_where = arel_table[:pattern].eq(cast_to_string(asn.arel))
    city_where = arel_table[:pattern].eq(cast_to_string(geoname.select(:geoname_id).arel))
    country_where = arel_table[:pattern].eq(cast_to_string(geoname.select(:country_iso_code).arel))

    where(type: :asn).where(asn_where).or(city.where(city_where)).or(country.where(country_where))
  end

  private_class_method def self.cast_to_string(arel)
    Arel::Nodes::NamedFunction.new('CAST', [
      Arel::Nodes::As.new(arel, Arel.sql('varchar'))
    ])
  end
end
