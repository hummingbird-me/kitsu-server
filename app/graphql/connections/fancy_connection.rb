class Connections::FancyConnection < GraphQL::Pagination::RelationConnection
  def initialize(loader, args, key, **super_args)
    @loader = loader
    @args = args
    @key = key
    @then = nil
    super(nil, **super_args)
  end

  # @return [Promise<Array<ApplicationRecord>>]
  def nodes
    if @then
      base_nodes.then(@then)
    else
      base_nodes
    end
  end

  def edges
    @edges ||= nodes.then do |nodes|
      nodes.map { |n| @edge_class.new(n, self) }
    end
  end

  # @return [Promise<Integer>]
  def total_count
    base_nodes.then do |results|
      if results.first
        results.first.attributes['total_count']
      else 0
      end
    end
  end

  # @return [Promise<Boolean>]
  def has_next_page # rubocop:disable Naming/PredicateName
    base_nodes.then do |results|
      if results.last
        results.last.attributes['row_number'] < results.last.attributes['total_count']
      else false
      end
    end
  end

  # @return [Promise<Boolean>]
  def has_previous_page # rubocop:disable Naming/PredicateName
    base_nodes.then do |results|
      if results.first
        results.first.attributes['row_number'] > 1
      else false
      end
    end
  end

  def start_cursor
    base_nodes.then do |results|
      cursor_for(results.first)
    end
  end

  def end_cursor
    base_nodes.then do |results|
      cursor_for(results.last)
    end
  end

  def cursor_for(item)
    item && encode(item.attributes['row_number'].to_s)
  end

  def then(&block)
    @then = block
    self
  end

  private

  def base_nodes
    @base_nodes ||= @loader.for(**loader_args).load(@key)
  end

  def after_offset
    @after_offset ||= after && decode(after).to_i
  end

  def before_offset
    @before_offset ||= before && decode(before).to_i
  end

  def loader_args
    @args.merge(
      token: context[:token],
      before: before_offset,
      after: after_offset,
      first: first,
      last: last
    )
  end
end
