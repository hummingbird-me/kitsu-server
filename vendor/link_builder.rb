# Pulled from https://github.com/cerebris/jsonapi-resources/blob/v0.9.6/lib/jsonapi/link_builder.rb
#
# Copyright (c) 2014-2021 Cerebris Corporation
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
module JSONAPI
  class LinkBuilder
    attr_reader :base_url,
                :primary_resource_klass,
                :route_formatter,
                :engine_name

    def initialize(config = {})
      @base_url               = config[:base_url]
      @primary_resource_klass = config[:primary_resource_klass]
      @route_formatter        = config[:route_formatter]
      @engine_name            = build_engine_name

      # Warning: These make LinkBuilder non-thread-safe. That's not a problem with the
      # request-specific way it's currently used, though.
      @resources_path_cache   = JSONAPI::NaiveCache.new do |source_klass|
        formatted_module_path_from_class(source_klass) + format_route(source_klass._type.to_s)
      end
    end

    def engine?
      !!@engine_name
    end

    def primary_resources_url
      if engine?
        engine_primary_resources_url
      else
        regular_primary_resources_url
      end
    end

    def query_link(query_params)
      "#{ primary_resources_url }?#{ query_params.to_query }"
    end

    def relationships_related_link(source, relationship, query_params = {})
      url = "#{ self_link(source) }/#{ route_for_relationship(relationship) }"
      url = "#{ url }?#{ query_params.to_query }" if query_params.present?
      url
    end

    def relationships_self_link(source, relationship)
      "#{ self_link(source) }/relationships/#{ route_for_relationship(relationship) }"
    end

    def self_link(source)
      if engine?
        engine_resource_url(source)
      else
        regular_resource_url(source)
      end
    end

    private

    def build_engine_name
      scopes = module_scopes_from_class(primary_resource_klass)

      begin
        unless scopes.empty?
          "#{ scopes.first.to_s.camelize }::Engine".safe_constantize
        end
      rescue LoadError => e
        nil
      end
    end

    def engine_path_from_resource_class(klass)
      path_name = engine_resources_path_name_from_class(klass)
      engine_name.routes.url_helpers.public_send(path_name)
    end

    def engine_primary_resources_path
      engine_path_from_resource_class(primary_resource_klass)
    end

    def engine_primary_resources_url
      "#{ base_url }#{ engine_primary_resources_path }"
    end

    def engine_resource_path(source)
      resource_path_name = engine_resource_path_name_from_source(source)
      engine_name.routes.url_helpers.public_send(resource_path_name, source.id)
    end

    def engine_resource_path_name_from_source(source)
      scopes         = module_scopes_from_class(source.class)[1..-1]
      base_path_name = scopes.map { |scope| scope.underscore }.join("_")
      end_path_name  = source.class._type.to_s.singularize
      [base_path_name, end_path_name, "path"].reject(&:blank?).join("_")
    end

    def engine_resource_url(source)
      "#{ base_url }#{ engine_resource_path(source) }"
    end

    def engine_resources_path_name_from_class(klass)
      scopes         = module_scopes_from_class(klass)[1..-1]
      base_path_name = scopes.map { |scope| scope.underscore }.join("_")
      end_path_name  = klass._type.to_s

      if base_path_name.blank?
        "#{ end_path_name }_path"
      else
        "#{ base_path_name }_#{ end_path_name }_path"
      end
    end

    def format_route(route)
      route_formatter.format(route)
    end

    def formatted_module_path_from_class(klass)
      scopes = module_scopes_from_class(klass)

      unless scopes.empty?
        "/#{ scopes.map{ |scope| format_route(scope.to_s.underscore) }.join('/') }/"
      else
        "/"
      end
    end

    def module_scopes_from_class(klass)
      klass.name.to_s.split("::")[0...-1]
    end

    def regular_resources_path(source_klass)
      @resources_path_cache.get(source_klass)
    end

    def regular_primary_resources_path
      regular_resources_path(primary_resource_klass)
    end

    def regular_primary_resources_url
      "#{ base_url }#{ regular_primary_resources_path }"
    end

    def regular_resource_path(source)
      "#{regular_resources_path(source.class)}/#{source.id}"
    end

    def regular_resource_url(source)
      "#{ base_url }#{ regular_resource_path(source) }"
    end

    def route_for_relationship(relationship)
      format_route(relationship.name)
    end
  end
end
