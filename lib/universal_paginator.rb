# frozen_string_literal: true

class UniversalPaginator < JSONAPI::Paginator
  attr_reader :params

  def initialize(params)
    super
    @params = params
    # Initialize sub-paginator
    paginator
  end

  def offset?
    if params&.fetch(:offset, nil) || params&.fetch(:limit, nil)
      true
    else
      false
    end
  end

  def page?
    !!offset?
  end

  def paginator
    @paginator ||= paginator_class.new(params)
  end

  def paginator_class
    offset? ? OffsetPaginator : PagedPaginator
  end

  delegate :calculate_page_count, to: :paginator
  delegate :links_page_params, to: :paginator

  def apply(relation, _order_options)
    if offset?
      paginator.apply(relation, _order_options)
    else
      params = params.to_h
      # We apply the PagedPaginator logic ourselves because it uses offset/limit
      # We want to have page/per method calls to be applied to the relation
      relation = relation.page(params[:number]) if params[:number].present?
      relation = relation.per(params[:size]) if params[:size].present?
      relation
    end
  end
end
